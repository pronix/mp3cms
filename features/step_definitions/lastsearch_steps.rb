Допустим /^в сервисе есть следующие прошедшие запросы$/ do |table|
  hash = table.hashes()
  hash.each {|i|
    Lastsearch.create(
      :search_string => i[:search_string],
      :site_attributes => i[:site_attributes],
      :site_section => i[:site_section]
    )
  }
end

