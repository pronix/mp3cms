authorization do

  # Не зарегистрированный пользователь
  role :guest do
    has_permission_on [:user_sessions], :to => [:new, :create, :destroy]
    has_permission_on [:welcome], :to => :read
    has_permission_on [:webmoney], :to => [:result, :fail, :success]
    has_permission_on [:mobilcents], :to => [:result, :status]
    has_permission_on [:orders], :to => :index
    has_permission_on [:playlists], :to => :read
    has_permission_on [:tracks], :to => :read
  end

  # Администратор
  role :admin do
    includes :user
    has_permission_on [:admin_roles],        :to => :manage
    has_permission_on [:admin_users],        :to => [:manage, :block, :unblock]
    has_permission_on [:admin_profits],      :to => [:show, :edit, :update]
    has_permission_on [:admin_gateways],     :to => :manage
    has_permission_on [:admin_payouts],      :to => :manage
    has_permission_on [:admin_transactions], :to => [:index]
    has_permission_on [:admin_cost_countries], :to => :manage
    has_permission_on [:admin_pages],          :to => :manage
    has_permission_on [:admin_settings],       :to => :manage
    has_permission_on [:admin_news_items], :to => [:manage, :news_list, :deleteimage, :approve]
    has_permission_on [:admin_searches], :to => [:show]
    has_permission_on [:orders], :to => [:manage, :found, :notfound]
    has_permission_on [:admin_servers], :to => :show
    has_permission_on [:admin_playlists], :to => [:manage, :complete]
    has_permission_on [:admin_tracks], :to => [:manage, :list, :complete, :upload, :abuza]
    has_permission_on [:admin_comments], :to => [:manage]
  end

  # Зарегистрированные пользователи
  role :user do
    includes :guest
    has_permission_on [:payments], :to => :read
    has_permission_on [:webmoney], :to => [:show, :pay]
    has_permission_on [:withdraws], :to => [:show, :create]
    has_permission_on [:mobilcents], :to => [:show, :pay]
    has_permission_on [:orders], :to => [:read, :create]
    has_permission_on [:tenders], :to => :create
    has_permission_on :orders do
      to :update, :delete, :found, :notfound
      if_attribute :user_id => is {user.id}
    end
    has_permission_on [:admin_playlists], :to => [:to_playlist, :index, :create, :to_cart]
    has_permission_on [:admin_playlists] do
      to :update, :delete, :show
      if_attribute :user_id => is {user.id}
    end
    has_permission_on [:admin_tracks], :to => [:create, :upload]
    has_permission_on [:admin_tracks] do
      to :update, :delete, :show
      if_attribute :user_id => is {user.id}
    end
    has_permission_on [:admin_comments], :to => :create
    has_permission_on [:admin_comments] do
      to :update, :delete
      if_attribute :user_id => is {user.id}
    end
  end

  # Модераторы
  role :moderator do
    includes :guest
  end

  # Права ролей созданных админом
  # Созданная группа с админскими правами
  role :custom_admin do
    includes :guest
    has_permission_on [:admin_roles], :to => :manage
  end
  # Созданная группа с правами на работу с плейлистами
  role :custom_playlist do
    includes :guest
  end

  # Созданная группа с правами на добавление mp3
  role :custom_add_mp3 do
    includes :guest
  end

  # Созданная группа с правами на бесплатное скачивание
  role :custom_free_download do
    includes :guest
  end

  # Созданная группа с правами на функционал нарезки треков
  role :custom_assorted_mp3 do
    includes :guest
    has_permission_on [:mp3_cuts], :to => [:show, :cut]
  end

  # Созданная группа с правами на добавление комментариев
  role :custom_comment do
    includes :guest
  end

end

privileges do
  privilege :manage, :includes => [:index, :create, :read, :update, :delete]
  privilege :read,   :includes => [:index, :show]
  privilege :create, :includes => :new
  privilege :update, :includes => :edit
  privilege :delete, :includes => :destroy
end

