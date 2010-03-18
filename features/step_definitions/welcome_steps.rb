Then /^(?:|я )перешел на главную страницу сервиса$/ do
  visit root_path
end

Given /^the following welcomes:$/ do |welcomes|
  Welcome.create!(welcomes.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) welcome$/ do |pos|
  visit welcomes_url
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following welcomes:$/ do |expected_welcomes_table|
  expected_welcomes_table.diff!(tableish('table tr', 'td,th'))
end
