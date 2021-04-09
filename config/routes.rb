Rails.application.routes.draw do
  root 'static_pages#home'
  resources :users, only: [:new, :create, :show]
  resources :expenses, only: [:new, :create, :show, :destroy, :edit, :update]
  resources :budgets, only: [:edit, :update]
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  get '/signup',  to: 'users#new'
  get '/welcome', to: 'sessions#welcome'
  get '/help', to: 'static_pages#help'
end
