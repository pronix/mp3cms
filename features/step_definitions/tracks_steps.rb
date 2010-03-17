def find_track(title)
  Track.find_by_title(title)
end

То /^есть следующие треки:$/ do |table|
  table.hashes.each do |hash|
    owner = User.find_by_email(hash["user_email"])
    playlist = Playlist.find_by_title(hash["playlist"])
    track = Factory :track,
            :title => hash["title"],
            :author => hash["author"],
            :bitrate => hash["bitrate"],
            :dimension => hash["dimension"],
            :playlist_id => playlist.id,
            :user_id => owner.id
    track.to_active if hash["state"] == "active"
    track.to_banned if hash["state"] == "banned"
    track.save
  end
end

То /^загружены следующие треки:$/ do |table|
  table.hashes.each do |hash|
    Допустим %(я зашел в сервис как "#{hash["user_email"]}/secret")
    И %(я на странице админки просмотра плейлиста "#{hash["playlist"]}")
    Если %(я введу в поле "track[title]" значение "#{hash["title"]}")
    И %(я введу в поле "track[author]" значение "#{hash["author"]}")
    И %(я прикреплю файл "test/files/file.mp3" в поле "track[data]")
    И %(я нажму "track_submit")
    И %(треку "#{hash["title"]}" присвоен статус "#{hash["state"]}")
    И %(я вышел из системы)
  end
end

То /^треку "([^\"]*)" присвоен статус "([^\"]*)"$/ do |трек, статус|
  track = find_track(трек)
  track.to_active if статус == "active"
  track.to_banned if статус == "banned"
  track.save
end

То /^я увижу следующие треки:$/ do |table|
  table.hashes.each_with_index do |hash, index|
    И %(я увижу "#{hash["author"]}" в "#track_#{index+1}_author")
    И %(я увижу "#{hash["title"]}" в "#track_#{index+1}_title")
  end
end

То /^я увижу следующие треки в таблице:$/ do |expected_tracks_table|
  expected_tracks_table.diff!(tableish('table#tracks tr', 'td,th'))
end

То /^трек "([^\"]*)" принадлежит пользователю "([^\"]*)"$/ do |track, user_email|
  user = User.find_by_email(user_email)
  find_track(track).user_id.should == user.id
end

То /^фай\w+ "([^\"]*)" буд\w+ забан\w+$/ do |track_titles|
  track_titles.split(", ").each do |title|
    find_track(title).state.should == "banned"
  end
end

То /^фай\w+ "([^\"]*)" буд\w+ актив\w+$/ do |track_titles|
  track_titles.split(", ").each do |title|
    find_track(title).state.should == "active"
  end
end

То /^фай\w+ "([^\"]*)" буд\w+ удал\w+$/ do |track_titles|
  track_titles.split(", ").each do |title|
    find_track(title).nil?
  end
end

Если /^трек "([^\"]*)" пройдет модерацию$/ do |track_title|
  track = find_track(track_title)
  track.to_active
  track.save
end

То /^я увижу песню "([^\"]*)" в плейлисте "([^\"]*)"$/ do |song, playlist|
  playlist = Playlist.find_by_title(playlist)
  visit admin_playlist_path(playlist)
  И %(я увижу "#{song}" в "#tracks")
end

То /^размер песни "([^\"]*)" будет ([0-9]+) б$/ do |track, dimension|
  find_track(track).data_file_size.should == dimension.to_i
end

То /^битрейт песни "([^\"]*)" будет ([0-9]+) кбит\/с$/ do |track, bitrate|
  find_track(track).bitrate.should == bitrate.to_i
end

