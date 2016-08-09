Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users
  get 'users/map/:id' => 'maps#show', as: :map

  root 'property#index'

  get 'property' => 'property#show'

  get 'sign_in' => 'sessions#new', as: :sign_in
  post 'sign_in' => 'sessions#create'
  delete 'sign_in' => 'sessions#delete'



end
