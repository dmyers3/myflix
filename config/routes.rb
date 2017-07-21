Myflix::Application.routes.draw do
  root to: 'users#front'
  get 'ui(/:action)', controller: 'ui'
  get '/home', to: 'videos#index'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'
  get 'register', to: 'users#new'
  get 'my_queue', to: 'queue_positions#index'
  post 'update_queue', to: 'queue_positions#update_queue', as: 'update_queue'
  
  resources :users, only: [:create, :show] do
  end
  get 'people', to: 'relationships#index'
  resources :relationships, only: [:destroy, :create]
  
  resources :categories, only: [:show]
  resources :queue_positions, only: [:create, :destroy]
  
  resources :videos, only: [:show] do
    collection do
      get 'search', to: 'videos#search'
      get 'advanced_search', to: 'videos#advanced_search'
    end
    resources :reviews, only: [:create]
  end
  
  get 'reset_password', to: 'password_tokens#new'
  post 'reset_passwords', to: 'password_tokens#create'
  delete 'password/:id', to: 'password_tokens#destroy'
  patch 'reset_password/:token', to: 'passwords#update'
  
  get 'confirm_reset_password', to: 'password_tokens#confirm'
  get 'expired_token', to: 'new_passwords#expired_token'
  
  resources :new_passwords, only: [:show, :create]
  resources :invitations, only: [:new, :create]
  
  namespace :admin do
    resources :videos, only: [:new, :create]
    resources :payments, only: [:index]
  end
  
  
  mount StripeEvent::Engine, at: '/stripe_events' # provide a custom path
  
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
