Given /^в сервисе есть следующие категории новостей$/ do |table|
  table.hashes.each { |h| Factory.create(:news_category, h)}
end

