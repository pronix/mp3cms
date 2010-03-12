Given /^the following roles:$/ do |roles|
  Admin::Roles.create!(roles.hashes)
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
