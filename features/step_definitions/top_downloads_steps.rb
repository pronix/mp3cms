Допустим /^были скачаны следующие треки:$/ do |table|
  table.hashes.each do |hash|
    track = Track.find_by_title(hash["title"])
    top_download = TopDownload.find_by_track_id(track.id)
    top_download.count_downloads = hash["count_downloads"].to_i
    top_download.last_download = hash["last_download"]
    top_download.save
  end
puts TopDownload.all.inspect

end

То /^я увижу следующие скачанные файлы:$/ do |table|
  table.hashes.each_with_index do |hash, index|
    И %(я увижу "#{hash["Название"]}" в "#tracks #track_#{index+1}_title")
    И %(я увижу "#{hash["Исполнитель"]}" в "#tracks #track_#{index+1}_author")
    И %(я увижу "#{hash["Скачано"]}" в "#tracks #track_#{index+1}_count_downloads")
  end
end

Если /^я обнулю счетчики скачанных треков$/ do
  TopDownload.update_all(["count_downloads = ?", "0"] )
end

То /^счетчик скачивания файла "([^\"]*)" будет равен "([^\"]*)"$/ do |track_title, count|
  track = Track.find_by_title(track_title)
  top_download = track.top_download
  top_download.count_downloads.should == count.to_i
end

