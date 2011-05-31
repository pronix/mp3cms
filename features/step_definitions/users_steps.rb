Given /^в сервисе есть следующие роли пользователей "([^\"]*)"$/ do |roles|
  roles.split(",").map{ |x|
    x[/(\w+)(?:|\()(.*)(?:|\))/]
    _role = $1
    _fields = $2[1..-2] unless $2.blank?
    _hash = { }
    _fields.split(';').map{|x| _hash[x.split(':').first] = x.split(':').last  } unless _fields.blank?
    Factory.create("#{_role.strip}_role".to_sym, _hash) unless Role.where(:name => _role.strip).first
  }
end

Given /^в сервисе есть следующие роли пользователей:$/ do |table|
  table.hashes.each do |hash|
    _hash = { }
    hash.each {|k,v|
      _hash[k] = case v ; when "true"; then true; when "false"; then false; else v end  }
    Factory.create(:role,_hash.merge({ :title  => hash["name"].strip})) unless Role.where(:name =>  hash["name"].strip).first
  end
end

Given /^в сервисе есть следующие пользователи:$/ do |table|
  User.destroy_all
  table.hashes.each do |hash|

    _hash = hash.except("roles").merge({
                         :password_confirmation => hash["password"].strip,
                         :roles => hash["roles"].split(',').map{|x|
                                           Role.find_by_title(x.strip)
                                         }
                        })
    Factory.create(:user,_hash)

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
Then /^в учетных данных пользователя "([^\"]*)" должны быть дополнительные данные:$/ do |email, table|
  user = User.find_by_email email
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
  all('a', :text => link).should be_present
end

Then /^(?:|я )увижу ссылку на выход из сервиса$/ do
  all('a', :text => I18n.t("logout")).should be_present
end

Then /^я увижу$/ do |string|
  if page.respond_to? :should
    page.should have_content(string)
  else
    assert page.has_content?(string)
  end
end

Given /^пользователь "([^\"]*)" заблокирован(?:| по ип адресу "([^\"]*)")$/ do |email_user, ip|

  user = User.find_by_email email_user
  user.block!({ :term_ban => 3, :ban_reason => "Жалуються пользователя",   :type_ban => (ip.blank? ? 1 : 2 )})
end

 #
Then /^я увижу окно потдверждения с "([^\"]*)"$/ do |text|
  selenium.get_confirmation.should ==  text
end

Then /^пользователь "([^\"]*)" будет заблокирован$/ do |email_user|
  user = User.find_by_email email_user
  user.ban?.should be_true
  user.type_ban.should == 2
  user.start_ban.should_not be_blank
  user.end_ban.should_not be_blank
end
When /^у пользователя "([^\"]*)" следующий ип адрес "([^\"]*)"$/ do |email_user, ip|
  user = User.find_by_email email_user
  user.current_login_ip = ip
  user.save
end

When /^я войду в систему как администратор$/ do
  Given %Q(я зашел в сервис как "admin_user@gmail.com/secret")
end

