ActionController::Routing::Routes.draw do |map|

  map.signup "/signup", :controller => "users", :action => "new"
  map.login  "/login",  :controller => "user_sessions", :action => "new"
  map.logout "/logout", :controller => "user_sessions", :action => "destroy"

  map.register '/register/:activation_code', :controller => 'activations', :action => 'new'
  map.activate '/activate/:id', :controller => 'activations', :action => 'create'

  # Reset password
  map.resources :password_resets


  map.resources :user_sessions, :only => [:new, :create, :destroy]
  map.resource :account, :controller => "users", :only => [:show, :edit, :update]

  map.resources :users

  map.root :controller => "welcome", :action => "index"


  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
