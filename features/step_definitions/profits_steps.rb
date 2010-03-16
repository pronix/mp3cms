Given /^the following profits:$/ do |profits|
  Profits.create!(profits.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) profits$/ do |pos|
  visit profits_url
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following profits:$/ do |expected_profits_table|
  expected_profits_table.diff!(tableish('table tr', 'td,th'))
end
