authorization do

  # Не зарегистрированный пользователь
  role :guest do
    has_permission_on [:user_sessions], :to => [:new, :create, :destroy]
    has_permission_on [:welcome], :to => :read
    has_permission_on [:webmoney], :to => [:result, :fail, :success]
    has_permission_on [:mobilcents], :to => [:result, :status]
  end

  # Администратор
  role :admin do
    includes :guest
    has_permission_on [:admin_roles],        :to => :manage
    has_permission_on [:admin_users],        :to => [:manage, :block, :unblock]
    has_permission_on [:admin_profits],      :to => [:show, :edit, :update]
    has_permission_on [:admin_gateways],     :to => :manage
    has_permission_on [:admin_payouts],      :to => :manage
    has_permission_on [:admin_transactions], :to => [:index]
    has_permission_on [:admin_cost_countries], :to => :manage
  end

  # Зарегистрированные пользователи
  role :user do
    includes :guest
    has_permission_on [:payments], :to => :read
    has_permission_on [:webmoney], :to => [:show, :pay]
    has_permission_on [:withdraws], :to => [:show, :create]
    has_permission_on [:mobilcents], :to => [:show, :pay]
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


