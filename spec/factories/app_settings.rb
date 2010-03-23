Factory.define :app_setting do |u|

end

Factory.define :app_settings_top_users, :parent => :app_setting do |u|
  u.code "top_users"
  u.name "Сколько пользователей выводить в топе"
  u.value "7"
end

Factory.define :app_settings_period_earnings, :parent => :app_setting do |u|
  u.code "period_earnings"
  u.name "Заработанная сумма за последние Х дней"
  u.value "7"
end
Factory.define :app_settings_add_files, :parent => :app_setting do |u|
  u.code "add_files"
  u.name "Добавлено файлов за Х дней"
  u.value "7"
end

Factory.define :app_settings_top_tracks, :parent => :app_setting do |u|
  u.code "top_tracks"
  u.name "Сколько треков выводить в топе"
  u.value "7"
end

Factory.define :app_settings_download_files, :parent => :app_setting do |u|
  u.code "download_files"
  u.name "Скачано файлов за Х дней"
  u.value "7"
end
