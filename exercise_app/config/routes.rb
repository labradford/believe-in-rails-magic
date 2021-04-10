Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'exercises#index'
  get 'exercises' => 'exercises#index', as: 'exercises'
  post 'exercises' => 'exercises#create'
  get 'exercises/new' => 'exercises#new', as: 'new_exercise'
  get 'exercises/:id' => 'exercises#show', as: 'exercise'
end
