Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")


  root 'welcome#index'
  get '/register', to: 'users#new', as: 'register_user'
  get '/login', to: 'sessions#login_form'
  post '/login', to: 'sessions#create'
  delete '/', to: 'sessions#destroy'

  resources :users, only: [:show, :create] do
    resources :discover, only: :index
    resources :movies, only: [:index, :show] do
      resources :similar, only: :index
      resources :viewing_party, only: [:new, :create, :show]
    end
  end
end
