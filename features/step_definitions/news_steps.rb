Given /^в категории "([^\"]*)" есть следующие новости$/ do |name, table|
  category = NewsCategory.find_by_name(name)
  table.hashes.each {|i|  Factory.create(:news_item,i.merge({:news_category_ids => [category.id] }))  }
end

Given /^новостей нет$/ do
  NewsItem.delete_all
end

