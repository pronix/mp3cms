ActionController::Routing::Routes.draw do |map|
  # Users
  map.signup    "/signup", :controller => "users", :action => "new"
  map.login     "/login",  :controller => "user_sessions", :action => "new"
  map.login_js  "/login.js",  :controller => "user_sessions", :action => "new", :format => "js"
  map.logout    "/logout", :controller => "user_sessions", :action => "destroy"
  map.cart      "/cart", :controller => "users", :action => "cart"



  map.resources :news_items, :as => "news"
  map.news_select "/news/t/:state", :controller => 'news_items', :action => 'index', :state => nil

  map.resource :searches


  map.register '/register/:activation_code', :controller => 'activations', :action => 'new'
  map.activate '/activate/:id', :controller => 'activations', :action => 'create'

  # Reset password
  map.resources :password_resets

  map.resources :user_sessions, :only => [:new, :create, :destroy]
  map.resource :account, :controller => "account", :only => [:show, :edit, :update]

  map.resources :users
  # --------- Users

  map.resources :orders, :member => {:found => :any, :notfound => :any} do |order|
    order.resources :tenders, :only => [:new, :create]
  end
  map.resources :tracks, :only => [:index, :show, :new, :create],
                         :collection => {:new_mp3 => :get, :top_mp3 => :get, :upload => :post}
  map.resources :top_downloads, :only => :index

  map.generate_file_link '/generate_link/:track_id', :controller => 'file_links', :action => 'generate'
  map.file_link '/download/:file_link.:format', :controller => 'file_links', :action => 'download'

  map.resources :archives, :only => [:create]
  map.archive_link '/download/archive/:archive_link.zip', :controller => 'archive_links', :action => 'download'

  map.resources :playlists, :only => [:index, :show] do |playlist|
    playlist.resources :comments
  end
  map.resource :payments
  map.resource :withdraws, :only => [:new, :create]

  map.resources :mp3_cuts, :as => "cuts", :only => [:show], :member => { :cut => :any }

  # Admin
  map.namespace :admin do |admin|
    admin.root :controller => "welcome", :action => "index"
    admin.resources :playlists, :collection => {:to_playlist => :post, :to_cart => :post}
    admin.resources :roles
    admin.resources :users, :member => { :block => :any, :unblock => :any  }
    admin.resources :comments
    admin.resources :news_items, :collection => {:deleteimage => :any}
    admin.resources :orders
    admin.resources :tracks,
                        :collection => { :complete => :any, :operation => :any, :upload => :any,
                        :abuza => :any, :save_in_session => :any, :clear_from_session => :any }
    admin.tracks_sort "/tracks_sort/:state", :controller => 'tracks', :action => 'list', :state => nil
    admin.resource :profits
    admin.searches "searches/:model", :controller => 'searches', :action => 'show', :model => nil

    admin.resources :gateways do |gateway|
      gateway.resources :cost_countries
    end
    admin.resources :payouts
    admin.resources :transactions, :only => [:index]
    admin.resources :pages
    admin.resources :settings, :only => [:index, :show, :edit, :update]
    admin.resource  :servers,  :only => :show
    admin.servers_stat 'servers/:image', :controller => :servers, :action => :show

  end

  map.admin_move_up_playlist_track '/playlists/:playlist_id/:track_id/move_up', :controller => 'admin/tracks', :action => 'move_up', :method => :post
  map.admin_move_down_playlist_track '/playlists/:playlist_id/:track_id/move_down', :controller => 'admin/tracks', :action => 'move_down', :method => :post

# diskio.png  network.png
  map.resource :webmoney, :as => "webmoney",:controller => "webmoney", :only => [:show],
  :collection => { :pay => :post,     # запрос на пополнение баланса
                   :result => :any,   # сюда будет возвращаться результат от wb
                   :success => :any,  # сюда будет возвращаться успешный результат от wb
                   :fail => :any }    # сюда будет возвращаться провальный результат от wb

  map.resource :mobilcents, :as => "mobilcents",:controller => "mobilcents", :only => [:show],
                            :collection => { :result => :any, :status => :any , :pay => :any}


  map.root :controller => "welcome", :action => "index"


  map.stat "/*path", :controller => "welcome", :action => "show"

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

