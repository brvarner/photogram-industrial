Rails.application.routes.draw do
  # Defines the root path route ("/")
  root "photos#index"
  
  resources :likes
  resources :follow_requests
  resources :comments
  resources :photos
  devise_for :users

  get ":username/liked" => "users#liked", as: :liked

  get ":username" => "users#show", as: :user

end
