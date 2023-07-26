Rails.application.routes.draw do
  devise_for :admins, controllers: { sessions: 'admins/sessions' }
  namespace :admin_administrate do
      resources :users, only: [:create, :index, :update, :show, :new, :destroy, :edit]
      # resources :achievements
      resources :machines, only: [:create, :index, :update, :show, :new, :destroy, :edit]
      resources :prizes, only: [:create, :index, :update, :show, :new, :destroy, :edit]
      resources :purchases
      resources :travel_sessions
      resources :partners, only: [:create, :index, :update, :show, :new, :destroy, :edit]
      resources :locations, only: [:create, :index, :update, :show, :new, :destroy, :edit]
      # resources :user_achievements
      resources :users_prizes

      root to: "users#index"
    end
  devise_for :users, controllers: { passwords: 'users/passwords', registrations: 'users/registrations', sessions: 'users/sessions' }
  devise_scope :user do
    get '/users/me', to: 'users/sessions#show'
    get '/users/passwords/success', to: 'users/passwords#show'
  end
  resources :high_scores, only: [:index]
  resources :tgtg_integrations, only: [:create, :update]
  get '/tgtg_integration', to: 'tgtg_integrations#show'
  resources :machines, only: [:index, :create]
  resources :machine_handlers, only: [:create]
  patch '/machine_handlers', to: 'machine_handlers#update'
  delete '/machine_handlers', to: 'machine_handlers#destroy'
  get '/carbon_savings', to: 'carbon_savings#show'
  resources :prizes, only: [:index]
  resources :users_prizes
  resources :locations, only: [:index]
  resources :partners, only: [:index] do
    get '/locations', to: 'partners/locations#index'
    get '/prizes', to: 'partners/prizes#index'
  end
  post '/purchases', to: 'purchases#create'
  resources :points_histories, only: [:index]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end