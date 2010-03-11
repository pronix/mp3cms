То /^есть следующие плейлисты:$/ do |table|
  table.hashes.each do |hash|
    Playlist.create!(hash)
  end
end

То /^я увижу следующие плейлисты:$/ do |expected_playlists_table|
  puts User.all.inspect
  expected_playlists_table.diff!(tableish('table#playlists tr', 'td,th'))
end

