Roomtemp::Application.routes.draw do
  resources :votes

  resources :rooms

  root :to => "home#index"
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users
end