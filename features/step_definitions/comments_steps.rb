То /^есть следующие комментарии плейлистов:$/ do |table|
  table.hashes.each do |hash|
    user = User.find_by_email hash["user_email"]
    object = Playlist.find_by_title hash["playlist"]
    object.add_comment user.comments.build(:title => hash["title"], :comment => hash["comment"])
  end
end

То /^я увижу следующие комментарии:$/ do |expected_comments_table|
  expected_comments_table.diff!(tableish('table#comments tr', 'td,th'))
end

То /^комментарий "([^\"]*)" принадлежит пользователю "([^\"]*)"$/ do |comment, user_email|
  comment = Comment.find_by_comment(comment)
  user = User.find_by_email(user_email)
  comment.user_id.should == user.id
end

