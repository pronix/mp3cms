Given /^the following transactions:$/ do |transactions|
  Transactions.create!(transactions.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) transactions$/ do |pos|
  visit transactions_url
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following transactions:$/ do |expected_transactions_table|
  expected_transactions_table.diff!(tableish('table tr', 'td,th'))
end
