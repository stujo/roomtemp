Roomtemp::Application.routes.draw do
  resources :current_votes

  resources :votes

  resources :rooms do
    get :vote, on: :member
    get '/report/:score', to: 'current_votes#report', as: 'room_report'
  end

  post '/temperatures', to: 'rooms#temperatures', as: 'room_temperatures'

  root :to => "home#index"
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users
end