Given /^в сервисе прописаны изменяемые параметры по умолчанию$/ do
  %w(top_users period_earnings add_files top_tracks download_files ).map{|x| Factory("app_settings_#{x}".to_sym) }
end
