Rails.application.routes.draw do
  devise_for :users
  resources :history_points, only: [:index]
  resources :travel_sessions, only: %i[create]
  resources :tgtg_integrations, only: [:create, :update]
  get '/tgtg_integration', to: 'tgtg_integrations#show'
  get '/carbon_savings', to: 'carbon_savings#show'
  patch '/update_travel_sessions', to: 'travel_sessions#update'
  delete '/delete_travel_sessions', to: 'travel_sessions#delete'
  resources :prizes
  resources :users_prizes
  post '/purchases', to: 'purchases#create'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end