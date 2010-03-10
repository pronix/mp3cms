Given /^в сервисе есть слеующие роли пользоватлей:$/ do |table|
  table.hashes.each do |hash|
    Factory(:role,
            :name => hash["name"],
            :system => hash["system"],
            :description => hash["description"])
  end
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
