Given /^в сервисе есть следующие роли пользователей "([^\"]*)"$/ do |roles|
  Role.destroy_all
  roles.split(",").map{ |x|  x[/(\w+)(?:|\()(.*)(?:|\))/]
    _role = $1
    _fields = $2[1..-2] unless $2.blank?
    _hash = { }
    _fields.split(';').map{|x| _hash[x.split(':').first] = x.split(':').last  } unless _fields.blank?
    Factory("#{_role.strip}_role".to_sym, _hash)
  }
end

Given /^в сервисе есть следующие роли пользователей:$/ do |table|
  Role.destroy_all
  table.hashes.each do |hash|
    _hash = { }
    hash.each {|k,v|
      _hash[k] = case v ; when "true"; then true; when "false"; then false; else v end  }
    Factory(:role,_hash.merge({ :title  => hash["name"].strip}))
  end
end

Given /^в сервисе есть следующие пользователи:$/ do |table|
  User.destroy_all
  table.hashes.each do |hash|
    _hash = hash.except("roles").merge({
                         :password_confirmation => hash["password"].strip,
                         :roles => hash["roles"].split(',').map{|x| Role.find_by_name(x.strip) }
                        })
    Factory(:user,_hash)
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
  if respond_to? :selenium
    response.should have_selector("a[href='#{account_path}']")
  else
    response.should have_tag("a[href='#{account_path}']", User.find_by_email(email_user).login)
  end
end

Then /^(?:|я )увижу ссылку на выход из сервиса$/ do
  if respond_to? :selenium
    response.should have_selector("a[href='#{logout_path}']")
  else
    response.should have_tag("a[href='#{logout_path}']", I18n.t("logout"))
  end
end

Then /^я увижу$/ do |string|
  if defined?(Spec::Rails::Matchers)
    response.should contain(string)
  else
    assert content.include?(string)
  end
end

Given /^пользователь "([^\"]*)" заблокирован$/ do |email_user|
  user = User.find_by_email email_user
  user.block!({ :term_ban => 3, :ban_reason => "Жалуються пользователя"})

end
 #
Then /^я увижу окно потдверждения с "([^\"]*)"$/ do |text|
  selenium.get_confirmation.should ==  text
end

