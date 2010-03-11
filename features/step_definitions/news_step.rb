Допустим /^в сервисе есть следующие новости$/ do |table|
  hash = table.hashes()
  hash.each {|i|
    NewsItem.create(
      :header => i[:header],
      :text => i[:text]
    )
  }
end

