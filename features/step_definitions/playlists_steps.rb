То /^есть следующие плейлисты:$/ do |table|
  table.hashes.each do |hash|
    owner = User.find_by_email hash["user_email"]
    Factory :playlist,
            :title => hash["title"],
            :description => hash["description"],
            :user_id => owner.id
  end
end

#То /^я увижу следующие плейлисты:$/ do |expected_playlists_table|
#  expected_playlists_table.diff!(tableish('table#playlists tr', 'td,th'))
#end

То /^я увижу следующие плейлисты:$/ do |table|
  table.hashes.each_with_index do |hash, index|
    И %(я увижу "#{hash["description"]}" в "#playlist_#{index+1}_description")
    И %(я увижу "#{hash["title"]}" в "#playlist_#{index+1}_title")
  end
end

То /^плейлист "([^\"]*)" принадлежит пользователю "([^\"]*)"$/ do |playlist, user_email|
  playlist = Playlist.find_by_title(playlist)
  user = User.find_by_email(user_email)
  playlist.user_id.should == user.id
end

