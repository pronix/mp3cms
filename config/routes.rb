ActionController::Routing::Routes.draw do |map|
  # Users
  map.signup "/signup", :controller => "users", :action => "new"
  map.login  "/login",  :controller => "user_sessions", :action => "new"
  map.logout "/logout", :controller => "user_sessions", :action => "destroy"


  map.resources :playlists
  map.resources :news
  map.resource :search, :collection => { :mp3 => :get, :playlists => :get, :news => :get }
  map.register '/register/:activation_code', :controller => 'activations', :action => 'new'
  map.activate '/activate/:id', :controller => 'activations', :action => 'create'


  # Reset password
  map.resources :password_resets


  map.resources :user_sessions, :only => [:new, :create, :destroy]
  map.resource :account, :controller => "users", :only => [:show, :edit, :update]

  map.resources :users
  # --------- Users

  map.resources :tracks

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  map.resources :playlists



  map.root :controller => "welcome", :action => "index"


  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

