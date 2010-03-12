То /^есть следующие плейлисты:$/ do |table|
  table.hashes.each do |hash|
    owner = User.find_by_email hash["user_email"]
    Factory :playlist,
            :title => hash["title"],
            :description => hash["description"],
            :user_id => owner.id
  end
end

То /^я увижу следующие плейлисты:$/ do |expected_playlists_table|
  expected_playlists_table.diff!(tableish('table#playlists tr', 'td,th'))
end

То /^плейлист "([^\"]*)" принадлежит пользователю "([^\"]*)"$/ do |playlist, user_email|
  playlist = Playlist.find_by_title(playlist)
  user = User.find_by_email(user_email)
  playlist.user_id.should == user.id
end

