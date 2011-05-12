Mp3cms::Application.routes.draw do
  get "abuses/index"

  root :to => "welcome#index"
  match '/signup' => 'users#new', :as => :signup
  match '/login' => 'user_sessions#new', :as => :login
  match '/logout' => 'user_sessions#destroy', :as => :logout
  match '/cart' => 'users#cart', :as => :cart
  match '/delete_from_cart.js' => 'users#delete_from_cart', :as => :delete_from_cart, :format => 'js'
  match '/authors/:char' => 'authors#index', :as => :authors
  resources :news_items, :path => "news" do
    collection do
      match "/:state" => 'news_items#index', :constraints => {:state => /fresh|top/ }, :as => :select
    end
  end
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
      match "/:state" => "tracks#index", :constraints => {:state => /my|active|moderation|fresh|top/ }, :as => :state
      post :upload
      match :top_100

      match :new_mp3
      match :top_mp3
      match :author
      match :ajax_new_mp3
      match :ajax_top_mp3

      match :new_mp3_for_main
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

  scope :controller => :welcome do
    match "welcome/:state" => "welcome#index", :constraints => {:state => /fresh|top/ }, :as => :root_tracks
  end

  match '/:controller(/:action(/:id))'
  match '/*path' => 'welcome#show', :as => :stat
end
