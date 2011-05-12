ActionController::Routing::Routes.draw do
  namespace :admin do
    root :to => "users#index"
    resources :abuses
    resources :playlists do
      collection do
        match :to_cart_from_playlist
        post :to_playlist
        post :to_cart
      end


    end
    resources :roles
    resources :users do
      member do
        match :block
        match :unblock
      end

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

end
