def user_comments(user_login)
  user = User.find_by_login(user_login)
  comments = Comment.find(:all, :conditions => {:user_id => user.id})
  return comments
end

def find_playlist
  Playlist.first
end

То /^есть следующие комментарии плейлистов:$/ do |table|
  table.hashes.each do |hash|
    user = User.find_by_email hash["user_email"]
    object = Playlist.find_by_title hash["playlist"]
    object.add_comment user.comments.build(:title => hash["title"], :comment => hash["comment"])
  end
end

То /^я увижу следующие комментарии:$/ do |table|
  table.hashes.each_with_index do |hash, index|
    И %(я увижу "#{hash["Автор"]}" в "#comment_#{index+1}_author")
    И %(я увижу "#{hash["Название"]}" в "#comment_#{index+1}_title")
    И %(я увижу "#{hash["Комментарий"]}" в "#comment_#{index+1}")
  end
end

То /^комментарий "([^\"]*)" принадлежит пользователю "([^\"]*)"$/ do |comment, user_email|
  comment = Comment.find_by_comment(comment)
  user = User.find_by_email(user_email)
  comment.user_id.should == user.id
end

То /^мне (разреш\w+|запре\w+) просмотр списка комментариев (плейлист\w+|новост\w+)$/ do |permission, type|
  if type =~ /плейлист/
    visit playlist_path(find_playlist)
    То "мне #{permission} доступ"
  else
    # сюда по новостям кусок кода
  end
end

То /^мне (разреш\w+|запре\w+) создание комментариев (плейлист\w+|новост\w+)$/ do |permission, type|
  if type =~ /плейлист/
    visit playlist_path(find_playlist)
    post admin_comments_path, {"switch" => "playlist", "object_id" => find_playlist.id}
    То "мне #{permission} доступ"
  else
    # сюда по новостям кусок кода
  end
end

То /^мне (разреш\w+|запре\w+) редактирование комментариев (плейлист\w+|новост\w+)$/ do |permission, type|
  if type =~ /плейлист/
    comments = find_playlist.comments
  else
    # сюда по новостям кусок кода
  end
  for comment in comments
    visit edit_admin_comment_path(comment)
    То "мне #{permission} доступ"
    put admin_comment_path(comment), {}
    То "мне #{permission} доступ"
  end
end

То /^мне (разреш\w+|запре\w+) удаление комментариев (плейлист\w+|новост\w+)$/ do |permission, type|
  for comment in Comment.all
    delete admin_comment_path(comment)
    То "мне #{permission} доступ"
  end
end

Если /^мне (разреш\w+|запре\w+) редактирование комментариев (плейлист\w+|новост\w+) пользователя "([^\"]*)"$/ do |permission, type, login|
  user_comments(login).each do |comment|
    visit edit_admin_comment_path(comment)
    То "мне #{permission} доступ"
  end
end

Если /^мне (разреш\w+|запре\w+) удаление комментариев (плейлист\w+|новост\w+) пользователя "([^\"]*)"$/ do |permission, type, login|
  user_comments(login).each do |comment|
    delete admin_comment_path(comment)
    То "мне #{permission} доступ"
  end
end

