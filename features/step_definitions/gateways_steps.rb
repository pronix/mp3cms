Given /^the following gateways:$/ do |gateways|
  Gateways.create!(gateways.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) gateways$/ do |pos|
  visit gateways_url
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following gateways:$/ do |expected_gateways_table|
  expected_gateways_table.diff!(tableish('table tr', 'td,th'))
end
