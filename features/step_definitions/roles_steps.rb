Then /^в сервисе должена появивться роль "([^\"]*)"$/ do |title_role|
  role = Role.find_by_title title_role
  role.should_not be_nil
  role.name.start_with?("custom").should be_true
end

Then /^у роль с ид "([^\"]*)" название должно быть "([^\"]*)"$/ do |_id, new_title|
  role = Role.find _id
  role.should_not be_nil
  role.title.should == new_title
end



When /^(?:|я ) delete the (\d+)(?:st|nd|rd|th) roles$/ do |pos|
  visit roles_url
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

When /^I delete the (\d+)(?:st|nd|rd|th) roles$/ do |pos|
  visit roles_url
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following roles:$/ do |expected_roles_table|
  expected_roles_table.diff!(tableish('table tr', 'td,th'))
end

