Допустим /^в сервисе есть следующие категории новостей$/ do |table|
  hash = table.hashes()
  hash.each {|i|
    NewsCategory.create!(
      :id => i[:header],
      :name => i[:name]
    )
  }
end

