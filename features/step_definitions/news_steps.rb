Given /^в сервисе есть следующие новости$/ do |table|
  table.hashes.each {|news|
    NewsItem.create!(:header => news[:header], :meta => news[:meta], :text => news[:text], :description => news[:description], :created_at => news[:created_at])
  }
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

Допустим /^я добавлю в поле "([^\"]*)" фаил "([^\"]*)"$/ do |field, file|
  file_path = File.join("test", "files", "images", file)
  fill_in(field, :with => file_path)
end

