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

То /^я увижу следующие треки:$/ do |expected_tracks_table|
  expected_tracks_table.diff!(tableish('table#tracks tr', 'td,th'))
end

То /^трек "([^\"]*)" принадлежит пользователю "([^\"]*)"$/ do |track, user_email|
  track = Track.find_by_title(track)
  user = User.find_by_email(user_email)
  track.user_id.should == user.id
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

