class ExercisesController < ApplicationController
  def index
    @exercises = Exercise.all
  end

  def show
    @exercise = Exercise.find(params[:id])
  end

  def new
    @exercise = Exercise.new
  end

  def create
    @exercise = Exercise.create(
      activity: params[:exercise][:activity],
      description: params[:exercise][:description]
    )
    if @exercise.save
      redirect_to root_path
    else
      render :new
    end
  end
end
