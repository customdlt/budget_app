Rails.application.routes.draw do
  get 'sessions/new'
  get 'sessions/create'
  get 'sessions/welcome'
  get 'users/new'
  get 'users/create'
  root 'static_pages#home'
  resources :users, only: [:new, :create]
  get '/signup',  to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/welcome', to: 'sessions#welcome'
end
