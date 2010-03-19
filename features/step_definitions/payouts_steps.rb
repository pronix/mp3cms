Given /^the following payouts:$/ do |payouts|
  Payouts.create!(payouts.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) payouts$/ do |pos|
  visit payouts_url
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following payouts:$/ do |expected_payouts_table|
  expected_payouts_table.diff!(tableish('table tr', 'td,th'))
end
