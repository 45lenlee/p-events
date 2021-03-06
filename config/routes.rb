Rails.application.routes.draw do
  root 'static_pages#home'
  get    '/help',     to: 'static_pages#help'
  get    '/about',    to: 'static_pages#about'
  get    '/signup',   to: 'users#new'
  post   '/signup',   to: 'users#create'
  resources :users
  get    '/login',    to: 'sessions#new'
  post   '/login',    to: 'sessions#create'
  delete '/logout',   to: 'sessions#destroy'
  resources :account_activations, only: [:edit]
  resources :events
  resources :invitations, only: [:create, :destroy]
end
