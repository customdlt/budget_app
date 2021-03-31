Rails.application.routes.draw do
  root 'static_pages#home'
  resources :users, only: [:new, :create, :show]
  resources :expenses, only: [:new, :create, :show]
  get 'expenses/new'
  get 'expenses/create'
  get 'sessions/new'
  get 'sessions/create'
  get 'sessions/welcome'
  get 'users/new'
  get 'users/create'
  get '/signup',  to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/welcome', to: 'sessions#welcome'
  get '/logout', to: 'sessions#destroy'
end
