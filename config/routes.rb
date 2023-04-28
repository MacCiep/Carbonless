Rails.application.routes.draw do
  devise_for :users, controllers: { passwords: 'users/passwords', registrations: 'users/registrations' }
  devise_scope :user do
    get '/users/passwords/success', to: 'users/passwords#show'
  end
  resources :tgtg_integrations, only: [:create, :update]
  get '/tgtg_integration', to: 'tgtg_integrations#show'
  resources :machines, only: [:index, :create]
  resources :machine_handlers, only: [:create]
  patch '/machine_handlers', to: 'machine_handlers#update'
  delete '/machine_handlers', to: 'machine_handlers#destroy'
  get '/carbon_savings', to: 'carbon_savings#show'
  resources :prizes
  resources :users_prizes
  post '/purchases', to: 'purchases#create'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end