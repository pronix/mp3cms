Mp3cm::Application.routes.draw do
  match '/signup' => 'users#new', :as => :signup
  match '/login' => 'user_sessions#new', :as => :login
  match '/login.js' => 'user_sessions#new', :as => :login_js, :format => 'js'
  match '/logout' => 'user_sessions#destroy', :as => :logout
  match '/cart' => 'users#cart', :as => :cart
  match '/delete_from_cart.js' => 'users#delete_from_cart', :as => :delete_from_cart, :format => 'js'
  match '/' => 'welcome#index'
  match '/authors/:char' => 'authors#index', :as => :authors
  resources :news_items
  # match '/news/t/:state' => 'news_items#index', :as => :news_select, :state =>
  #   resource :searches
  match '/register/:activation_code' => 'activations#new', :as => :register
  match '/activate/:id' => 'activations#create', :as => :activate
  match '/actemail/:token/:email' => 'activations#actemail', :as => :activate_email
  resources :password_resets
  resources :user_sessions, :only => [:new, :create, :destroy, :redirect] do
    collection do
      any :redirect
    end


  end

  resource :account, :only => [:show, :edit, :update]
  resources :users
  resources :orders do


    resources :tenders
  end

  match '/orders' => 'orders#notfoundorders', :as => :table_orders
  resources :tracks, :only => [:index, :show, :new, :create, :my] do
    collection do
      post :upload
      any :top_100
      any :my
      any :new_mp3
      any :my_active_mp3
      any :top_mp3
      any :my_on_moderation_mp3
      any :author
      any :ajax_new_mp3
      any :new_mp3_for_main
      any :ajax_top_mp3
      any :top_mp3_for_main
    end
    member do
      any :play
    end

  end

  match '/generate_link/:track_id' => 'file_links#generate', :as => :generate_file_link
  match '/download/:file_link.:format' => 'file_links#download', :as => :file_link
  resources :archives, :only => [:create]
  match '/download/archive/:archive_link.zip' => 'archive_links#download', :as => :archive_link
  resources :playlists do


    resources :comments
  end

  resource :payments do
    collection do
      any :history
    end


  end

  resource :withdraws, :only => [:new, :create]
  resources :mp3_cuts, :only => [:show] do

    member do
      any :cut
    end

  end

  namespace :admin do
    resources :playlists do
      collection do
        any :to_cart_from_playlist
        post :to_playlist
        post :to_cart
      end


    end
    resources :roles
    resources :users do


      resources :transactions do
        collection do
          any :user_transaction
        end


      end
    end
    resources :comments
    resources :news_items do
      collection do
        any :approve
        any :deleteimage
      end


    end
    resources :orders
    resources :tracks do
      collection do
        any :upload
        any :operation
        any :complete
        any :abuza
        any :save_in_session
        any :clear_from_session
      end


    end
    match 'listen_track/:id' => 'welcome#index', :as => :listen_track
    # match '/tracks_sort/:state' => 'tracks#list', :as => :tracks_sort, :state =>
    #   resource :profits
    # match 'searches/:model' => 'searches#show', :as => :searches, :model =>
    #   resources :gateways do


    #   resources :cost_countries
    # end
    resources :payouts
    resources :transactions, :only => [:index]
    resources :pages
    resources :settings, :only => [:index, :show, :edit, :update]
    resource :servers, :only => :show
    resources :satellites do
      collection do
        any :newmaster
      end


    end
    resources :orders do


      resources :tenders, :only => [] do

        member do
          get :deny
          get :accept
        end

      end
    end
    match 'servers/:image' => 'servers#show', :as => :servers_stat
    match 'delete_from_playlist/:playlist_id/:id/' => 'admin/tracks#delete_from_playlist', :as => :delete_from_playlist, :via => 'delete'
    match 'delete_from_playlist/:playlist_id/:id.js' => 'admin/tracks#delete_from_playlist', :as => :delete_from_playlist_js, :via => 'delete', :format => 'js'
  end

  match 'move_up/:playlist_id/:track_id/' => 'admin/tracks#move_up', :as => :move_up_track, :via => 'post'
  match 'move_down/:playlist_id/:track_id/' => 'admin/tracks#move_down', :as => :move_down_track, :via => 'post'
  match 'move_up/:playlist_id/:track_id.js' => 'admin/tracks#move_up', :as => :move_up_track_js, :via => 'post', :format => 'js'
  match 'move_down/:playlist_id/:track_id.js' => 'admin/tracks#move_down', :as => :move_down_track_js, :via => 'post', :format => 'js'
  match 'delete_from_playlist/:playlist_id/:id/' => 'admin/tracks#delete_from_playlist', :as => :delete_from_playlist, :via => 'delete'
  match 'delete_from_playlist/:playlist_id/:id.js' => 'admin/tracks#delete_from_playlist', :as => :delete_from_playlist_js, :via => 'delete', :format => 'js'
  resource :webmoney, :only => [:show] do
    collection do
      any :success
      any :result
      post :pay
      any :fail
    end


  end

  resource :mobilcents, :only => [:show] do
    collection do
      any :status
      any :result
      any :pay
    end


  end

  match '/:controller(/:action(/:id))'
  match '/*path' => 'welcome#show', :as => :stat
end
