ActionController::Routing::Routes.draw do |map|
  # Users
  map.signup    "/signup", :controller => "users", :action => "new"
  map.login     "/login",  :controller => "user_sessions", :action => "new"
  map.login_js  "/login.js",  :controller => "user_sessions", :action => "new", :format => "js"
  map.logout    "/logout", :controller => "user_sessions", :action => "destroy"
  map.cart      "/cart", :controller => "users", :action => "cart"
  map.delete_from_cart "/delete_from_cart.js", :controller => "users", :action => "delete_from_cart", :format => "js"
  map.root :controller => "welcome", :action => "index"


  map.resources :news_items, :as => "news"
  map.news_select "/news/t/:state", :controller => 'news_items', :action => 'index', :state => nil

  map.resource :searches


  map.register '/register/:activation_code', :controller => 'activations', :action => 'new'
  map.activate '/activate/:id', :controller => 'activations', :action => 'create'
  map.activate_email '/actemail/:token/:email', :controller => 'activations', :action => 'actemail'

  # Reset password
  map.resources :password_resets

  map.resources :user_sessions, :only => [:new, :create, :destroy, :redirect], :collection => { :redirect => :any}
  map.resource :account, :controller => "account", :only => [:show, :edit, :update]

  map.resources :users
  # --------- Users

  map.resources :orders, :collection => {:found => :any, :notfoundorders => :any, :close_not_found_order => :any} do |order|
    order.resources :tenders
  end

  map.resources :tracks, :only => [:index, :show, :new, :create, :my],
                         :collection => {:new_mp3 => :any, :top_mp3 => :any, :ajax_new_mp3 => :any, :ajax_top_mp3 => :any, :upload => :post, :author => :any, :my => :any, :my_active_mp3 => :any, :my_on_moderation_mp3 => :any, :new_mp3_for_main => :any, :top_mp3_for_main => :any, :top_100 => :any},
                         :member => {:play => :any}

  map.generate_file_link '/generate_link/:track_id', :controller => 'file_links', :action => 'generate'
  map.file_link '/download/:file_link.:format', :controller => 'file_links', :action => 'download'

  map.resources :archives, :only => [:create]
  map.archive_link '/download/archive/:archive_link.zip', :controller => 'archive_links', :action => 'download'

  map.resources :playlists, :only => [:index, :show] do |playlist|
    playlist.resources :comments
  end
  map.resource :payments, :collection => { :history => :any }
  map.resource :withdraws, :only => [:new, :create]

  map.resources :mp3_cuts, :as => "cuts", :only => [:show], :member => { :cut => :any }

  # Admin
  map.namespace :admin do |admin|
    admin.resources :playlists, :collection => {:to_playlist => :post, :to_cart => :post, :to_cart_from_playlist => :any}
    admin.resources :roles
    admin.resources :users, :member => { :block => :any, :unblock => :any  } do |users|
      users.resources :transactions, :collection => { :user_transaction => :any }
    end
    admin.resources :comments
    admin.resources :news_items, :collection => {:deleteimage => :any, :approve => :any}
    admin.resources :orders
    admin.resources :tracks,
                        :collection => { :complete => :any, :operation => :any, :upload => :any,
                        :abuza => :any, :save_in_session => :any, :clear_from_session => :any }
    admin.listen_track "listen_track/:id", :controller => "welcome", :action => "index"
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
    admin.resource :servers, :only => :show
    admin.resources :satellites, :collection => {:newmaster => :any}
    admin.servers_stat 'servers/:image', :controller => :servers, :action => :show
    map.delete_from_playlist 'delete_from_playlist/:playlist_id/:id/', :controller => 'admin/tracks', :action => 'delete_from_playlist', :method => :delete
    map.delete_from_playlist_js 'delete_from_playlist/:playlist_id/:id.js', :controller => 'admin/tracks', :action => 'delete_from_playlist', :method => :delete, :format => "js"
  end

  map.move_up_track 'move_up/:playlist_id/:track_id/', :controller => 'admin/tracks', :action => 'move_up', :method => :post
  map.move_down_track 'move_down/:playlist_id/:track_id/', :controller => 'admin/tracks', :action => 'move_down', :method => :post
  map.move_up_track_js 'move_up/:playlist_id/:track_id.js', :controller => 'admin/tracks', :action => 'move_up', :method => :post, :format => "js"
  map.move_down_track_js 'move_down/:playlist_id/:track_id.js', :controller => 'admin/tracks', :action => 'move_down', :method => :post, :format => "js"
  map.delete_from_playlist 'delete_from_playlist/:playlist_id/:id/', :controller => 'admin/tracks', :action => 'delete_from_playlist', :method => :delete
  map.delete_from_playlist_js 'delete_from_playlist/:playlist_id/:id.js', :controller => 'admin/tracks', :action => 'delete_from_playlist', :method => :delete, :format => "js"

# diskio.png  network.png
  map.resource :webmoney, :as => "webmoney",:controller => "webmoney", :only => [:show],
  :collection => { :pay => :post,     # запрос на пополнение баланса
                   :result => :any,   # сюда будет возвращаться результат от wb
                   :success => :any,  # сюда будет возвращаться успешный результат от wb
                   :fail => :any }    # сюда будет возвращаться провальный результат от wb

  map.resource :mobilcents, :as => "mobilcents",:controller => "mobilcents", :only => [:show],
                            :collection => { :result => :any, :status => :any , :pay => :any}






  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.stat "/*path", :controller => "welcome", :action => "show"
end

