Допустим /^в сервисе есть следующие плей листы$/ do |table|
  hash = table.hashes()
  hash.each { |i|
    Playlist.create(
      :title => i[:title],
      :description => i[:description],
      :icon_file_name => i[:icon_file_name],
      :icon_content_type => i[:icon_content_type],
      :icon_file_size => i[:icon_file_size],
      :icon_updated_at => i[:icon_updated_at],
      :user_id => i[:user_id]
    )
  }

end

