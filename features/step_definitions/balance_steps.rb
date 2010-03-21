Given /^пользователю "([^\"]*)" делаем начисление "([^\"]*)"$/ do |email_user, credit_method|
  user = User.find_by_email email_user
  user.send credit_method.to_sym, "Test"

end

When /^баланс пользователя "([^\"]*)" равен "([^\"]*)"$/ do |email_user, balance|
  user = User.find_by_email email_user
  user.balance.to_f.should == balance.to_f
end

Given /^пользователь "([^\"]*)" закреплен за "([^\"]*)"$/ do |email_user1, email_user2|
  user1 = User.find_by_email email_user1
  user2 = User.find_by_email email_user2
  user1.referrer = user2
  user1.save
end
