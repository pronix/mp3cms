Допустим /^в облаке тегов есть$/ do |table|
  table.hashes.each {|cloud|
    TagCloud.create!(:url_string => cloud[:url_string], :url_attributes => cloud[:url_attributes], :url_model => cloud[:url_model])
  }
end

