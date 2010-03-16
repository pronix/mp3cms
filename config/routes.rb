ActionController::Routing::Routes.draw do |map|
  # Users
  map.signup "/signup", :controller => "users", :action => "new"
  map.login  "/login",  :controller => "user_sessions", :action => "new"
  map.logout "/logout", :controller => "user_sessions", :action => "destroy"


  map.resource :search, :collection => { :mp3 => :get, :playlists => :get, :news => :get }
  map.register '/register/:activation_code', :controller => 'activations', :action => 'new'
  map.activate '/activate/:id', :controller => 'activations', :action => 'create'


  # Reset password
  map.resources :password_resets


  map.resources :user_sessions, :only => [:new, :create, :destroy]
  map.resource :account, :controller => "account", :only => [:show, :edit, :update]

  map.resources :users
  # --------- Users

  map.resources :tracks, :only => [:index, :show]
  map.resources :playlists, :only => [:index, :show] do |playlist|
    playlist.resources :comments
  end
  map.resource :payments

  # Admin
  map.namespace :admin do |admin|
    admin.resources :playlists
    admin.resources :roles
    admin.resources :users, :member => { :block => :any, :unblock => :any  }
    admin.resources :comments
    admin.resources :tracks, :member => { :change_state => :get }, :collection => {:complete => :put}
    admin.tracks_sort "/tracks_sort/:state", :controller => 'tracks', :action => 'list', :state => nil
    admin.resource :profits
  end

  #map.download_track '/admin/track/:track_id/', :controller => 'admin/tracks', :action => 'download'

  map.root :controller => "welcome", :action => "index"

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

