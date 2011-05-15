def user(email)
  User.find_by_email(email)
end

Given /^пользователю "([^\"]*)" делаем начисление "([^\"]*)"$/ do |email_user, credit_method|
  user(email_user).send credit_method.to_sym, "Test"
end

When /^баланс пользователя "([^\"]*)" равен "([^\"]*)"$/ do |email_user, balance|
  user(email_user).balance.to_f.should == balance.to_f
end

Given /^пользователь "([^\"]*)" закреплен за "([^\"]*)"$/ do |email_user1, email_user2|
  user1 = User.find_by_email email_user1
  user2 = User.find_by_email email_user2
  user1.referrer = user2
  user1.save
end

Then /^у пользователя "([^\"]*)" было снятие баланса за размещение заказа$/ do |email_user|
  @user = User.find_by_email(email_user)
  @user.transactions.where(:kind_transaction => "order_track").last.should be_present
end

То /^пользователю "([^\"]*)" было начисление баланса за выполнение заказа$/ do |email_user|
  user(email_user).transactions.inspect.to_s.should contain("find_track")
end

То /^у пользователя "([^\"]*)" было пополнение баланса за загрузку нормального трека$/ do |email_user|
  user(email_user).transactions.inspect.to_s.should contain("upload_track")
end

То /^у пользователя "([^\"]*)" было снятие баланса за скачивание трека$/ do |email_user|
  @user = User.find_by_email(email_user)
  @user.transactions.where(:kind_transaction => "download_track").last.should be_present
end

