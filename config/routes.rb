Mp3cms::Application.routes.draw do
  root :to => "welcome#index"
  match '/signup' => 'users#new', :as => :signup
  match '/login' => 'user_sessions#new', :as => :login
  match '/logout' => 'user_sessions#destroy', :as => :logout
  match '/cart' => 'users#cart', :as => :cart
  match '/delete_from_cart.js' => 'users#delete_from_cart', :as => :delete_from_cart, :format => 'js'
  match '/authors/:char' => 'authors#index', :as => :authors
  resources :news_items
  match '/news/t/(:state)' => 'news_items#index', :as => :news_select
  resource :searches

  match '/register/:activation_code' => 'activations#new', :as => :register
  match '/activate/:id' => 'activations#create', :as => :activate
  match '/actemail/:token/:email' => 'activations#actemail', :as => :activate_email
  resources :password_resets
  resources :user_sessions, :only => [:new, :create, :destroy, :redirect] do
    collection do
      get :redirect, :via => [:post, :get]
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
      match "/:state" => "tracks#index", :constraints => {:state => /my|active|moderation|fresh/ }, :as => :state
      post :upload
      match :top_100

      match :new_mp3
      # match :my_active_mp3
      match :top_mp3
      # match :my_on_moderation_mp3
      match :author
      match :ajax_new_mp3
      match :new_mp3_for_main
      match :ajax_top_mp3
      match :top_mp3_for_main
    end
    member do
      :play
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
      match :history
    end
  end

  resource :withdraws, :only => [:new, :create]
  resources :mp3_cuts, :only => [:show] do

    member do
      match :cut
    end

  end

  namespace :admin do
    resources :playlists do
      collection do
        match :to_cart_from_playlist
        post :to_playlist
        post :to_cart
      end


    end
    resources :roles
    resources :users do


      resources :transactions do
        collection do
          match :user_transaction
        end
      end
    end

    resources :comments
    resources :news_items do
      collection do
        match :approve
        match :deleteimage
      end
    end

    resources :orders
    resources :tracks do
      collection do
        match :upload
        match :operation
        match :complete
        match :abuza
        match :save_in_session
        match :clear_from_session
      end
    end

    match 'listen_track/:id' => 'welcome#index', :as => :listen_track
    match '/tracks_sort/(:state)' => 'tracks#list', :as => :tracks_sort
    resource :profits
    match 'searches/(:model)' => 'searches#show', :as => :searches
    resources :gateways do
       resources :cost_countries
    end

    resources :payouts
    resources :transactions, :only => [:index]
    resources :pages
    resources :settings, :only => [:index, :show, :edit, :update]
    resource :servers, :only => :show
    resources :satellites do
      collection do
        match :newmaster
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
  resource :webmoney, :only => [:show], :controller => "webmoney" do
    collection do
      match :success
      match :result
      post :pay
      match :fail
    end


  end

  resource :mobilcents, :only => [:show] do
    collection do
      match :status
      match :result
      match :pay
    end


  end

  match '/:controller(/:action(/:id))'
  match '/*path' => 'welcome#show', :as => :stat
end
