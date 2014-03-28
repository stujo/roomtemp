Roomtemp::Application.routes.draw do
  resources :current_votes

  resources :votes

  resources :rooms

  root :to => "home#index"
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users
end