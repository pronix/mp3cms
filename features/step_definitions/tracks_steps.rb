def find_track(title)
  Track.find_by_title(title)
end

То /^загружены следующие треки:$/ do |table|
  table.hashes.each do |hash|
    playlist = Playlist.find_by_title(hash["playlist"])
    user = User.find_by_email(hash["user_email"])
    track = Factory(:track,
            :user_id => user.id,
            :title => hash["title"],
            :author => hash["author"],
            :data_file_name => "#{hash["title"].parameterize}.mp3")
    track.playlists << playlist
    track.to_active if hash["state"] == "active"
    track.to_banned if hash["state"] == "banned"
    track.data_file_size = hash["data_file_size"] if hash["data_file_size"]
    track.bitrate = hash["bitrate"] if hash["bitrate"]
    track.save
  end
end

Допустим /^загружены в систему следующие треки:$/ do |table|
  table.hashes.each do |hash|
    Допустим %(я зашел в сервис как "#{hash["user_email"]}/secret")
    И %(я на странице админки просмотра плейлиста "#{hash["playlist"]}")
    Если %(я введу в поле "track_1[title]" значение "#{hash["title"]}") if hash["title"]
    И %(я введу в поле "track_1[author]" значение "#{hash["author"]}") if hash["author"]
    file_name = hash["file_name"].blank? ? "normal.mp3" : hash["file_name"]
    И %(я прикреплю файл "test/files/#{file_name}" в поле "track_1[data]")
    И %(я нажму "track_submit")
    И %(треку "#{hash["title"]}" присвоен статус "#{hash["state"]}") if hash["title"]
    if hash["file_name"]
      track = Track.find_by_data_file_name(file_name)
      track.state = hash["state"]
      track.save
    end
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
    И %(я увижу "#{hash["Исполнитель"]}" в "#tracks #track_#{index+1}_author")
    И %(я увижу "#{hash["Название"]}" в "#tracks #track_#{index+1}_title")
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
  visit playlist_path(playlist)
  И %(я увижу "#{song}" в "#tracks")
end

То /^размер песни "([^\"]*)" будет ([0-9]+) б$/ do |track, dimension|
  find_track(track).data_file_size.should == dimension.to_i
end

То /^битрейт песни "([^\"]*)" будет ([0-9]+) кбит\/с$/ do |track, bitrate|
  find_track(track).bitrate.should == bitrate.to_i
end

Если /^я прикреплю ([0-9]+) фай\w+$/ do |count_files|
  Array.new(count_files.to_i).each_index do |index|
    И %(я введу в поле "track_#{index+1}[title]" значение "Трек #{index+1}")
    И %(я прикреплю файл "test/files/normal.mp3" в поле "track_#{index+1}[data]")
  end
end

Если /^треки пройдут модерацию$/ do
  for track in Track.all
    track.to_active
  end
end

То /^я увижу ([0-9]+) новых тре\w+ на странице$/ do |count_tracks|
  Array.new(count_tracks.to_i).each_index do |index|
    И %(я увижу "Трек #{index+1}" в "#tracks")
  end
end

Если /^задача будет запущена$/ do
  Delayed::Job.reserve_and_run_one_job
end

То /^треки "([^\"]*)" появятся в плейлисте "([^\"]*)"$/ do |tracks, playlist|
  И %(я на странице просмотра плейлиста "#{playlist}")
  tracks.split(", ").each do |track|
    И %(я увижу "#{track}" в "#tracks")
  end
end

