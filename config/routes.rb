Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users
  get 'users/map/:id' => 'maps#show', as: :map

  root 'maps#index'


end
