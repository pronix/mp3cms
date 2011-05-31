Given /^в сервисе прописаны изменяемые параметры по умолчанию$/ do
  [:top_users,       :period_earnings, :add_files, :top_tracks, :download_files].each do |m|
    Factory.create(:"app_settings_#{m}") unless AppSetting.where(:code => m).first
  end

end
