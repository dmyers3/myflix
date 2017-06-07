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
  
  resources :users, only: [:create] do
  end
  
  resources :categories, only: [:show]
  resources :queue_positions, only: [:create, :destroy]
  
  resources :videos, only: [:show] do
    collection do
      get 'search', to: 'videos#search'
    end
    resources :reviews, only: [:create]
  end
  
  
  
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
