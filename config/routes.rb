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
  
  post "/book-and-seat" => 'appointments#book_and_seat', :as => :book_and_seat
  
  match "/auth/:provider/callback" => "sessions#create"
  post "/signout" => "sessions#destroy", :as => :signout
  
  post "/text-message" => "appointments#sendtext"
  post "/seat/:id" => "appointments#seat"
  
  match "/customer" => "customers#index"
  match "/customer/:id" => "customers#show"
  
end
