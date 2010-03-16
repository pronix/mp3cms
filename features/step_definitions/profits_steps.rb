Given /в сервисе записана стоимости по умолчанию$/ do
  [:upload_track, :find_track,:add_news,
   :refferer_bonus,:download_track,:order_track,:assorted_track,:min_amount_payout  ].each { |x| Factory(x)}
end

When /^(?:|я )изменил поле стомости "([^\"]*)" для "([^\"]*)" на "([^\"]*)"$/ do |field, param, value|
  _param = Profit.find_by_name param.strip
  fill_in("profits[#{_param.id}][#{field}]", :with => value)
end

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
