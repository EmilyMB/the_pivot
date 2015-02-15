Rails.application.routes.draw do

  root "welcome#index"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy", as: "logout"

  resources :categories, only: [:show, :index]
  resources :projects
  get "cart_projects/create"

  post '/carts', to: 'carts#create', as: 'carts'
  get '/pending_loan', to: 'carts#show', as: 'pending_loan'
  post '/cart', to: 'carts#checkout_cart', as: 'checkout_cart'
  delete '/cart', to: 'carts#delete_item', as: 'cart'
  put '/cart', to: 'carts#update_project_amount', as: 'update_project_amount'

  namespace :admin do
    get "/dashboard", to: "base#dashboard"
  end

  resources :users do
    resources :orders
  end

  scope ":slug", module: "tenants", as: "tenant" do
    get "/" => "projects#index"
    resources :projects
    get "/dashboard" => "dashboard#show"
  end

  match "/create_order", via: [:get], to: "orders#create"
end
