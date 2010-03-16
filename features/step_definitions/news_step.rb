
Допустим /^в категории "([^\"]*)" есть следующие новости$/ do |name, table|
  category = NewsCategory.find_by_name(name)
  hash = table.hashes()
  hash.each {|i|
    NewsItem.create!(
      :id => i[:id],
      :header => i[:header],
      :meta => i[:meta],
      :text => i[:text],
      :news_category_ids => [category.id]
    )

  }
end

Допустим /^новостей нет$/ do
  NewsItem.delete_all
end

