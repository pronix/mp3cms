Given /^в сервисе есть следующие треки$/ do |table|
  hash = table.hashes()
  hash.each {|i|
    Track.create(
      :title => i[:title],
      :author => i[:author],
      :bitrate => i[:bitrate],
      :dimension => i[:dimension],
      :playlist_id => i[:playlist_id]
    )
  }
end

