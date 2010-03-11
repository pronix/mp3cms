Given /^в сервисе есть следующие роли пользоватлей:$/ do |table|
  table.hashes.each do |hash|
    Factory(:role,
            :name => hash["name"],
            :system => hash["system"],
            :description => hash["description"])
  end
end

Given /^в сервисе есть следующие пользователи:$/ do |table|
  table.hashes.each do |hash|
    Factory(:user,
            :login => hash["login"],
            :email => hash["email"],
            :password => hash["password"],
            :password_confirmation => hash["password"],
            :active => hash["active"],
            :roles => hash["roles"].split(',').map{|x| Factory("#{x.strip}_role".to_s) })
  end

end

Given /^пользователя "([^\"]*)" забанили$/ do |email_user|
  user = User.find_by_email email_user
  user.ban = true
  user.start_ban = Time.now.to_s(:db)
  user.end_ban = (Time.now + 1.week).to_s(:db)
  user.ban_reason = "Ваша учетная запись заблокирована.<br />На Вас нажаловались за популязацию Rammstain.<br />Учетная запись будет разблокирована 01.05.2010"
  user.save
end
Then /^в учетных данных пользователя "([^\"]*)" должны быть дополнительные данные:$/ do |user, table|
  user = User.find_by_login user
  table.raw.each do |r|
    user.send(r[0].to_s).should == r[1]
  end
end



Given /^the following users:$/ do |users|
  Users.create!(users.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) users$/ do |pos|
  visit users_url
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following users:$/ do |expected_users_table|
  expected_users_table.diff!(tableish('table tr', 'td,th'))
end
Then /^(?:|я )увижу ссылку "([^\"]*)"$/ do |link|
  response.should have_tag("a",  link)
end

Then /^(?:|я )увижу ссылку на учетную запись для "(.*)"$/ do |email_user|
  response.should have_tag("a[href='#{account_path}']", User.find_by_email(email_user).login)
end

Then /^(?:|я )увижу ссылку на выход из сервиса$/ do
  response.should have_tag("a[href='#{logout_path}']", I18n.t("logout"))
end

Then /^я увижу$/ do |string|
  if defined?(Spec::Rails::Matchers)
    response.should contain(string)
  else
    assert content.include?(string)
  end
end

