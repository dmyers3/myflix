Myflix::Application.routes.draw do
  root to: 'users#front'
  get 'ui(/:action)', controller: 'ui'
  get '/home', to: 'videos#index'
  get '/categories/:id', to: 'categories#show'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'
  get 'register', to: 'users#new'
  
  
  resources :users, only: [:create]
  
  
  resources :videos, only: [:show] do
    collection do
      get 'search', to: 'videos#search'
    end
  end
  
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
