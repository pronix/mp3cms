Если /^я отправлю в корзину следующие треки:$/ do |table|
  table.hashes.each do |hash|
    user = current_user
    user = Track.find_by_title hash["Название"]
    track = Factory :track,
            :playlist_id => playlist.id,
            :user_id => user.id,
            :title => hash["title"],
            :author => hash["author"],
            :data_file_name => "#{hash["title"].parameterize}.mp3"
    track.to_active if hash["state"] == "active"
    track.to_banned if hash["state"] == "banned"
    track.data_file_size = hash["data_file_size"] if hash["data_file_size"]
    track.bitrate = hash["bitrate"] if hash["bitrate"]
    track.save
  end
end

