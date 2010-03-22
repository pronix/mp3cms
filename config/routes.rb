ActionController::Routing::Routes.draw do |map|
  # Users
  map.signup "/signup", :controller => "users", :action => "new"
  map.login  "/login",  :controller => "user_sessions", :action => "new"
  map.logout "/logout", :controller => "user_sessions", :action => "destroy"


  map.resources :news_items
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
  #map.download_track '/track/:track_id/:format', :controller => 'tracks', :action => 'download'

  map.generate_file_link '/generate_link/:track_id', :controller => 'file_links', :action => 'generate'
  map.file_link '/download/:file_link.:format', :controller => 'file_links', :action => 'download'

  map.resources :playlists, :only => [:index, :show] do |playlist|
    playlist.resources :comments
  end
  map.resource :payments
  map.resource :withdraws, :only => [:new, :create]

  # Admin
  map.namespace :admin do |admin|
    admin.root :controller => "welcome", :action => "index"
    admin.resources :playlists
    admin.resources :roles
    admin.resources :users, :member => { :block => :any, :unblock => :any  }
    admin.resources :comments
    admin.resources :news_items
    admin.resources :news_categories do |news_catigories|
      news_catigories.resources :news_items, :collection => { :news_list => :get }
    end
    admin.resources :tracks, :collection => {:complete => :put, :operation => :any, :upload => :put}

    admin.tracks_sort "/tracks_sort/:state", :controller => 'tracks', :action => 'list', :state => nil
    admin.resource :profits

    admin.resources :searches, :collection => { :news_items => :get, :playlists => :get,
                                                :mp3 => :get, :user => :get}
    admin.resources :gateways
    admin.resources :payouts
    admin.resources :transactions, :only => [:index]
  end


  map.resource :webmoney, :as => "webmoney",:controller => "webmoney", :only => [:show],
  :collection => { :pay => :post,     # запрос на пополнение баланса
                   :result => :any,   # сюда будет возвращаться результат от wb
                   :success => :any,  # сюда будет возвращаться успешный результат от wb
                   :fail => :any }    # сюда будет возвращаться провальный результат от wb

  map.resource :mobilcents, :as => "mobilcents",:controller => "mobilcents", :only => [:show],
                            :collection => { :result => :any, :status => :any }


  map.root :controller => "welcome", :action => "index"

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

