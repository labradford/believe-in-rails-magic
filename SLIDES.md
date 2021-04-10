# SLIDES

By following the pattern of RESTful routes, we can implement CRUD functionality into a Rails application.

## User stories

### As a developer, I can create an exercise tracking application.

For the first step, we will need to create a new Rails application and create the database for it.

  ```
    rails new exercise_app
  ```
  ```
    cd exercise_app
  ```
  ```
    rails db:create
  ```
  ```
    rails server
  ```
  In a browser navigate to: http://localhost:3000

### As a developer, the exercise tracker will have an activity and a description.

For this step, we will generate the Exercise model. To keep it simple, we will have two string fields: activity and description.

  ```
  rails generate model Exercise activity:string description:string
  ```
  ```
  rails db:migrate
  ```

### As a developer, I can add new exercise entries directly to my database.

  We can add individual exercise entries directly into the database using the rails console:

  ```
  bundle exec rails c
  ```

  Create a few exercise entries:
  ```
  e = Exercise.new
  e.activity = "Weight Training"
  e.description = "Leg day at the gym."
  e.save
  ```

### As a user, I can see all the exercise entries listed on the home page of the application.

For this step, we will need to generate a controller, add an index action to the controller, add an index view page, and add an index route to the routes file.

To generate the controller:

  ```
    rails generate controller exercises
  ```

The next step is to create a controller method that will access all the items from the database. In the index method, we are making an Active Record call that will save all the content from the database as an instance variable.

In the ExercisesController app/controllers/exercises_controller.rb:

  ```
    def index
      @exercises = Exercise.all
    end
  ```

To create the view, we will add a new file to the exercises directory called index.html.erb. The file matches the name of the controller method index. In the view we will use a combination of HTML tags and embedded Ruby to map through the Active Record array and record each value into a list.

To create the index view, add a file to app/views/exercises named index.html.erb and add:

  ```
    <h1>Exercise App</h1>

    <% @exercises.each do |exercise| %>
      <h3>
        <%= exercise.activity %>
      </h3>
      <p>
        <%= exercise.description %>
      </p>
    <% end %>

  ```

  Now we will make a route that will call the index method. Since we are returning content, the request type will be a GET request.
  
  We will also be adding the root route. This route will allow our exercises index page to display as our home page. 
  
  We will be adding a route alias which we will be using when we are adding links to our views. 
  
  In the config.routes file:

  ```
    root 'exercises#index'
    get 'exercises' => 'exercises#index', as: 'exercises'
  ```

### As a user, I can click on the activity of an exercise and be routed to a page where I see the activity and description of the exercise entry I selected.

  To create a show page for exercises, we will need an action in the controller, a route, and a show page view. We will also need to create a link to this new page in the index view.

  Show is a RESTful route that looks for one item in the database. This is done by accessing the id of the item. Inside the show method we will make an Active Record call that will find one item by id. This id will come from the url params.
  
  In the app/controllers/exercises_controller.rb:

  ```
    def show
      @exercise = Exercise.find(params[:id])
    end
  ```

  To create the view for show, we will add a new file to the exercises directory called show.html.erb. In the view we will use a combination of HTML tags and embedded Ruby to list the attributes of the exercise.
  
  Create a show page view in app/views/exercises named show.html.erb and add this code:

  ```
    <h3><%= @exercise.activity %></h3>
    <p><%= @exercise.description %></p>
  ```

  Now, we will make a route that will call the show method. Because we need to extract just one item, we need the show route to expect a param. Since we are returning content, the request type will be a GET request.
  
  Add a route in config/routes.rb:

  ```
    get 'exercises/:id' => 'exercises#show', as: 'exercise' 
  ```

  To add a link to the show page from the index page, we will be using the Rails link_to method. This method takes two arguments, one for the text and the other for the route. Notice we are using the route alias for the second argument.
  
  Update the app/views/index.html.erb file with a link to the new show page:

  ```
    <%= link_to exercise.activity, exercise_path(exercise.id) %>
  ```


### As a user, I can navigate from the show page back to the home page.

  To make it easy to get back to the home/index page, let's use the link_to method. In app/views/show.html.erb:

  ```
    <%= link_to 'Back to home', exercises_path %>
  ```

  or:

  ```
    <%= link_to 'Back to home', root_path %>
  ```

  Can you see the difference between the two?

### As a user, I see a form where I can create a new exercise entry.

  As developers, we want our users to be able add information to our web application that is then stored in the database. We can create a form for that purpose.

  New is a RESTful route that displays a form for the user.

  In the app/controllers/exercises_controller.rb:

  ```
    def new
      @exercise = Exercise.new
    end
  ```

  To create the view for new, we will add a new file to the exercises directory called new.html.erb. In the view we will use a Ruby helper method to create form inputs. Each input will have a label and a text field for the user to enter content.

  With the release of Rails 6, we get a very convenient method called form_with that allows us to use a series of helper methods to create form elements. Form elements are items such as text inputs, radio button, and labels. By using the form_with method we can create forms in true Ruby-like fashion. When the code renders, Rails translates it into the corresponding HTML form tags.

  form_with takes a code block and passes a local variable. In this example, the variable is |form| but it can be called whatever you want as long as it clearly communicates your intent. Form helper methods are then applied to the variable form and passed a symbol of each attribute.

  Create a new file app/views/exercises named new.html.erb and add this code:

  ```
    <h3>Add a New Exercise Session</h3>
    <%= form_with model: @exercise do |form| %>

      <%= form.label :activity %>
      <%= form.text_field :activity %>

      <br>
      <%= form.label :description %>
      <%= form.text_field :description %>

      <br>
      <%= form.submit 'Add Exercise' %>
    <% end %>
  ```

  Now we will make a route that will take the user to a page with a form. Since we are returning content, the request type will be a get request.

  In config/routes.rb:

  ```
    get 'exercises/new' => 'exercises#new', as: 'new_exercise'
  ```

  Why do you think we are using a get request and not a post request?

### As a user, I can click a button that will take me from the home page to a page where I can create an exercise entry.

  Now that we have a form, let's give the user access to it by adding a link to the home page.

  In the app/views/exercises/index.html.erb:

  ```
  <p><%= link_to 'New Exercise', new_exercise_path %></p>
  ```

### As a user, I can navigate from the form back to the home page.
  
  Sometimes a user might change their mind and not want to create a new exercise activity. Let's give them a way to cancel and return back to the home page.

  In app/views/exercises/new.html.erb:

  ```
    <p><%= link_to 'Back to home', root_path %></p>
  ```
  or
  ```
    <p><%= link_to 'Back to home', exercises_path %></p>
  ```

### As a user, I can click a button that will submit my exercise entry to the database.

  We've already set up our form and the get request to display the form to our user. But if we click the submit form, we get an error. This is because we need to set up a post request to add the information from the form into the database. In Rails, this means setting up the create action.

  We will need to add the create action to our exercises controller and add a route to our routes file.

  Create is a RESTful route that submits user data to the database.

  In app/controllers/exercise_controller.rb:

  ```
    def create
      @exercise = Exercise.create(
        activity: params[:exercise][:activity],
        description: params[:exercise][:description]
      )
    end
  ```

  There is no view associated with the create method.

  Next, we will make a route that will call the create method. Since we are submitting content to the database, the request type will be a post request.

  In confib/routes.rb:

  ```
    post 'exercises' => 'exercises#create'
  ```

### As a user, I when I submit my post, I am redirected to the home page.
  We should think about what kind of user experience we want to create when our user creates a new item. One option is to trigger a redirect after the successful creation of a new item.

  We can do this in the create method in the excercises controller. 

  In the create method in app/controllers/exercises_controller:

  ```
    if @exercise.save
      redirect_to root_path
    else
      render :new
    end
  ```

## Stretch Challenges

### Implement Rails strong parameters

Submitted form data is put into the params Hash, along with the route parameters. The create action can access the submitted activity via params[:exercise][:activity] and the submitted description via params[:exercise][:description]. 

In the last user story, we passed these values individually to Exercise.new, but that is a bit confusing and can cause errors.

Instead, we can pass a single hash that contains the values. We must specify what values are allowed in that params hash. Otherwise, a malicious user could potentially submit extra form fields and overwrite private data. 

We will use a feature of Rails called strong parameters to do this.

For this user story, we will need to add a private method to the bottom of app/controllers/exercises_controller.rb named exercise_params, we will update the create method to use it:

```
  private

    def exercise_params
      params.require(:exercise).permit(:activity, :description)
    end
```

```
  def create
    @exercise = Exercise.new(exercise_params)

    if @exercise.save
      redirect_to root_path
    else
      render :new
    end
  end
```

### As a user, I can delete my excercise activities.
  Deleting a resource is a simpler process than creating or updating. It only requires a route and a controller action.

  In the app/controllers/exercises_controller.rb:

  ```
    def destroy
      @exercise = Exercise.find(params[:id])
      @exercise.destroy

      redirect_to root_path
    end

  ```

  In the config/routes.rb:

  ```
    delete 'exercises/:id' => 'exercises#destroy', as: 'destroy_exercise'

  ```

  And finally, we can add the link to delete in our index view. Make sure to add this code inside of the 'each' method where we are mapping through each of the exercise entries.

  In app/views/exercises/index.html.erb:

  ```
    <ul>
      <li>
        <%= link_to "Delete activity", destroy_exercise_path(exercise),
        method: :delete, data: { confirm: "Are you sure?" } %>
      </li>
    </ul>
  ```

### As a user, I can edit/update my exercise activities.
  Can you use the work we did for creating a new exercise activity to add the ability to edit an existing activity?

  You will need methods in the exercises_controller for edit and update. They will mostly follow the same pattern as new and create.
  
  The edit method in app/controllers/exercises_controller will be the same as the new method:

  ```
    def edit
      @exercise = Exercise.find(params[:id])
    end
  ```
  
  Inside the update method we will make an Active Record call that will find one item by id. This id will come from the url params. We will need to set the instance variable for @exercise to the entry that you want to edit.
  
  In the update method in app/controllers/exercises_controller.rb:

  ```
    def update
      @exercise = Exercise.find(params[:id])

      if @exercise.update(exercise_params)
        redirect_to root_path
      else
        render :edit
      end
    end

  ```

  You will need to add a view file for the edit form. This should look similar to the new form, except we will be changing the text in the Heading and on the submit button.

  Create a file in app/views/exercises called edit.html.erb:

  ```
    <h3>Edit an Exercise Session</h3>
    <%= form_with model: @exercise do |form| %>

      <%= form.label :activity %>
      <%= form.text_field :activity %>

      <br>
      <%= form.label :description %>
      <%= form.text_field :description %>

      <br>
      <%= form.submit 'Update Exercise' %>
    <% end %>

    <p><%= link_to 'Back to home', root_path %></p>

  ```

  You will need to add RESTful routes in the config/routes.rb file:

  ```
    get 'exercises/edit' => 'exercises#edit', as: 'edit_exercise'
    patch 'exercises/:id' => 'exercises#update'
  ```
  **WARNING**
  The order for your routes matters. Make sure to put your edit and update routes before the show route

  Finally, you will need to add a link_to method on the index page that will send you to the edit form. You will need to pass the id of the exercise entry in the link. 
  
  In app/views/exercises/index.html:

  ```
    <li>
      <%= link_to 'Edit activity', edit_exercise_path(id: exercise.id) %>
    </li>
  ```

  This line should be inside of the `<ul>` that we created during the delete story. 

  ### As a developer, I would like to see Rails magically create all of this for me