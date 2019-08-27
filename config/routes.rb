Rails.application.routes.draw do
  get 'toppages/index'
  root to: 'toppages#index'
  
  resources :articles do
    resource :favorites, only: [:create, :destroy, :update, :edit]
    resources :comments
    member do
      patch :release
      patch :nonrelease
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  get 'signup', to: 'users#new'
  resources :users do
    member do
      get :followings
      get :followers
      get :likes
    end
  end
  
  resources :relationships, only: [:create, :destroy]
end
