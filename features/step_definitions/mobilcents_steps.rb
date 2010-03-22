Given /^the following mobilcents:$/ do |mobilcents|
  Mobilcents.create!(mobilcents.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) mobilcents$/ do |pos|
  visit mobilcents_url
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following mobilcents:$/ do |expected_mobilcents_table|
  expected_mobilcents_table.diff!(tableish('table tr', 'td,th'))
end
