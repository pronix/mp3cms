Given /^в категории "([^\"]*)" есть следующие новости$/ do |name, table|
  category = NewsCategory.find_by_name(name)
  table.hashes.each {|i|  Factory.create(:news_item,i.merge({:news_category_ids => [category.id] }))  }
end

Given /^новостей нет$/ do
  NewsItem.delete_all
end


То /^есть следующие комментарии новостей:$/ do |table|
  table.hashes.each do |hash|
    user = User.find_by_email hash["user_email"]
    object = Playlist.find_by_title hash["playlist"]
    object.add_comment user.comments.build(:title => hash["title"], :comment => hash["comment"])
  end
end

