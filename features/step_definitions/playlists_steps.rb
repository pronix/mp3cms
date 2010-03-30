def user_playlists(user_login)
  user = User.find_by_login(user_login)
  playlists = Playlist.find(:all, :conditions => {:user_id => user.id})
  return playlists
end

То /^есть следующие плейлисты:$/ do |table|
  table.hashes.each do |hash|
    owner = User.find_by_email hash["user_email"]
    Factory :playlist,
            :title => hash["title"],
            :description => hash["description"],
            :user_id => owner.id
  end
end

То /^я увижу следующие плейлисты:$/ do |table|
  table.hashes.each_with_index do |hash, index|
    И %(я увижу "#{hash["description"]}" в "#playlists #playlist_#{index+1}_description") if hash["description"]
    И %(я увижу "#{hash["title"]}" в "#playlists #playlist_#{index+1}_title")
  end
end

То /^плейлист "([^\"]*)" принадлежит пользователю "([^\"]*)"$/ do |playlist, user_email|
  playlist = Playlist.find_by_title(playlist)
  user = User.find_by_email(user_email)
  playlist.user_id.should == user.id
end

То /^мне (разреш\w+|запре\w+) просмотр списка плейлистов$/ do |permission|
  visit playlists_path
  То "мне #{permission} доступ"
end

То /^мне (разреш\w+|запре\w+) посещение админки управления плейлистами$/ do |permission|
  visit admin_playlists_path
  То "мне #{permission} доступ"
end

То /^мне (разреш\w+|запре\w+) просмотр плейлистов$/ do |permission|
  for playlist in Playlist.all
    visit playlist_path(playlist)
    То "мне #{permission} доступ"
  end
end

То /^мне (разреш\w+|запре\w+) создание плейлистов$/ do |permission|
  visit new_admin_playlist_path
  Then "мне #{permission} доступ"
end

То /^мне (разреш\w+|запре\w+) редактирование плейлистов$/ do |permission|
  for playlist in Playlist.all
    visit edit_admin_playlist_path(playlist)
    То "мне #{permission} доступ"
  end
end

То /^мне (разреш\w+|запре\w+) удаление плейлистов$/ do |permission|
  for playlist in Playlist.all
    delete admin_playlist_path(playlist)
    То "мне #{permission} доступ"
  end
end

Если /^мне (разреш\w+|запре\w+) редактирование плейлистов пользователя "([^\"]*)"$/ do |permission, login|
  user_playlists(login).each do |playlist|
    visit edit_admin_playlist_path(playlist)
    То "мне #{permission} доступ"
  end
end

Если /^мне (разреш\w+|запре\w+) удаление плейлистов пользователя "([^\"]*)"$/ do |permission, login|
  user_playlists(login).each do |playlist|
    delete admin_playlist_path(playlist)
    То "мне #{permission} доступ"
  end
end

