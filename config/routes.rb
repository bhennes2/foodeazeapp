FoodEazeApp::Application.routes.draw do
  
  resources :appointments
  #match '/appointments' => 'appointments#index'
  #match '/appointments/archive' => 'appointments#archive', :as => '/archive'
  
  root :to => 'pages#index'

  match '/main' => 'pages#main'
  
  match '/metrics' => 'pages#metrics', :as => :metrics
  
  get '/layout' => 'TableType#index', :as => :layout
  post '/layout' => 'TableType#create', :as => :table_types
  delete '/layout/:id' => 'TableType#destroy', :as => :table_type
  
  resources :posts
  
  match "/auth/:provider/callback" => "sessions#create"
  match "/signout" => "sessions#destroy", :as => :signout
  
  match "/text-message" => "appointments#sendtext"
  match "/seat" => "appointments#seat"
  
  match "/customer" => "customers#index"
  match "/customer/:id" => "customers#show"
  
end
