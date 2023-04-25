Rails.application.routes.draw do
  devise_for :users
  resources :travel_sessions, only: %i[create]
  resources :tgtg_integrations, only: [:create, :update]
  get '/tgtg_integration', to: 'tgtg_integrations#show'
  resources :machines, only: [:index, :create]
  resources :machine_handlers, only: [:create]
  patch '/machine_handlers', to: 'machine_handlers#update'
  get '/carbon_savings', to: 'carbon_savings#show'
  patch '/update_travel_sessions', to: 'travel_sessions#update'
  delete '/delete_travel_sessions', to: 'travel_sessions#destroy'
  resources :prizes
  resources :users_prizes
  post '/purchases', to: 'purchases#create'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end