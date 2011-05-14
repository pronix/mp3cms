Given /^в сервисе есть следующие новости$/ do |table|
  table.hashes.each {|news|
    NewsItem.create!(:header => news[:header],
                      :meta => news[:meta],
                      :text => news[:text],
                      :description => news[:description],
                      :created_at => news[:created_at],
                      :state => news[:state],
                      :user_id => 1)
  }

end


Given /^в сервисе есть следующие новости которые оформил "([^\"]*)"$/ do |user_login, table|
  user = User.find_by_login(user_login)
  table.hashes.each {|news|
    NewsItem.create!(:header => news[:header],
                      :meta => news[:meta],
                      :text => news[:text],
                      :description => news[:description],
                      :created_at => news[:created_at],
                      :state => news[:state],
                      :user_id => user.id)
  }
end

Given /^новостей нет$/ do
  NewsItem.delete_all
end


Then /^есть следующие комментарии новостей:$/ do |table|
  table.hashes.each do |hash|
    user = User.find_by_email hash["user_email"]
    object = Playlist.find_by_title hash["playlist"]
    object.add_comment user.comments.build(:title => hash["title"], :comment => hash["comment"])
  end
end

When /^я добавлю в поле "([^\"]*)" файл "([^\"]*)"$/ do |field, file|
  path = File.join("test", "files", "images", file)
  attach_file(field, File.expand_path(path))
end


