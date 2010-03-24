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

То /^у пользователя "([^\"]*)" было снятие баланса за размещение заказа$/ do |email_user|
  user(email_user).transactions.inspect.to_s.should contain("order_track")
end

То /^пользователю "([^\"]*)" было начисление баланса за выполнение заказа$/ do |email_user|
  user(email_user).transactions.inspect.to_s.should contain("find_track")
end

