Given /^в категории "([^\"]*)" есть следующие новости$/ do |name, table|
  category = NewsCategory.find_by_name(name)
  table.hashes.each {|i|
    Factory.create(:news_item,
                   :id => i[:id],
                   :header => i[:header],
                   :meta => i[:meta],
                   :text => i[:text],
                   :news_category_ids => [category.id],
                   :description => i[:description])
  }
end

Given /^новостей нет$/ do
  NewsItem.delete_all
end

