Factory.define :user do |u|
  u.login "user"
  u.email "user@example.com"
  u.password "password"
  u.password_confirmation "password"
end

Factory.define :admin, :parent => :user do |a|
  a.login "admin"
  a.email "admin@example.com"
  a.roles {|factory| [factory.association(:admin_role)]}
  a.active true
end

Factory.define :active_user, :parent => :user do |u|
  u.active true
end


Factory.define :user_waiting_activation, :parent => :user do |u|
  u.active false
  u.perishable_token  "abcd"
end

Factory.define :user_requesting_password, :parent=>:user do |u|
  u.perishable_token  "abcd"
end



# :admin,                     # Доступ в админку - да/нет
# :add_news_with_moderation,  # Добавление новостей с предмодерацией - да/нет
# :upload_on_ftp,             # Аплоад на фтп сервер - да/нет
# :add_mp3,                   # Добавление мп3 на сайт - да/нет
# :moderation_all_mp3,        # Модерация всех mp3 - да/нет
# :moderation_your_mp3,       # Модерация своих mp3 - да/нет
# :free_download,             # Бесплатное скачивание мп3 - да/нет
# :captcha_before_download,   # Капча перед скачиванием - да/нет
# :award_points,              # Начислять баллы за действия - да/нет
# :assorted_mp3,              # Разрешить мод нарезки файла - да/нет
# :playlist,                  # Разрешить плейлисты - да/нет
# :comment,                   # Разрешить комментарии - да/нет
# :captcha_before_comment,    # Капча для камента - да/нет


Factory.define :role do |r|
end

Factory.define :admin_role, :parent => :role do |r|
  r.name "admin"
  r.title "admin"
  r.system true
  r.admin true
  r.description "administrator"
end

Factory.define :user_role, :parent => :role do |r|
  r.name "user"
  r.title "user"
  r.system true
  r.admin false
  r.description "user"
end
Factory.define :moderator_role, :parent => :role do |r|
  r.name "moderator"
  r.title "moderator"
  r.system true
  r.admin false
  r.description "moderator"
end

[ :add_news_with_moderation,  :upload_on_ftp, :add_mp3, :moderation_all_mp3,
  :moderation_your_mp3, :free_download, :captcha_before_download,
  :award_points, :assorted_mp3, :playlist, :comment, :captcha_before_comment].each do |m|
  Factory.define "custom_#{m}_role", :parent => :role do |r|
    r.name "#{m.to_s}"
    r.title "custom_#{m}"
    r.system false
    r.admin false
    r.description "#{m}"
    r.add_attribute m, true
  end
end
