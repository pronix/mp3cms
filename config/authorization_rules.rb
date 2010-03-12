authorization do

  # Не зарегистрированный пользователь
  role :guest do
  end

  # Администратор
  role :admin do
    has_permission_on [:admin_roles], :to => :manage
  end

  # Зарегистрированные пользователи
  role :user do
  end

  # Модераторы
  role :moderator do
  end

  # Права ролей созданных админом
  # Созданная группа с админскими правами
  role :custom_admin do
    has_permission_on [:admin_roles], :to => :manage
  end
  # Созданная группа с правами на работу с плейлистами
  role :custom_playlist do
  end

  # Созданная группа с правами на добавление mp3
  role :custom_add_mp3 do
  end

  # Созданная группа с правами на бесплатное скачивание
  role :custom_free_download do
  end

  # Созданная группа с правами на функционал нарезки треков
  role :custom_assorted_mp3 do
  end

  # Созданная группа с правами на добавление комментариев
  role :custom_comment do
  end

end

privileges do
  privilege :manage, :includes => [:index, :create, :read, :update, :delete]
  privilege :read,   :includes => [:index, :show]
  privilege :create, :includes => :new
  privilege :update, :includes => :edit
  privilege :delete, :includes => :destroy
end


