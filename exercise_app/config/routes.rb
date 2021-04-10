Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'exercises#index'
  get 'exercises' => 'exercises#index', as: 'exercises'
  get 'exercises/:id' => 'exercises#show', as: 'exercise'
end
