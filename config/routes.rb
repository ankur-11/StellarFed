Rails.application.routes.draw do
  root to: 'static#welcome'
  devise_for :users, controllers: { registrations: 'registrations' }
  get '/.well-known/stellar.toml' => 'static#stellar'
  get '/federation' => 'users#federation_search'
  get '/search' => 'users#search'
  get '/u/:id' => 'users#show', id: /.*/, as: 'user'
  resources :accounts, only: [:show, :destroy]
end
