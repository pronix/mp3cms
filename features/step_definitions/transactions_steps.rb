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

Допустим /^в сервисе прошли следующие транзакции для пользователя "([^\"]*)"$/ do |login, table|
  table.hashes.each do |hash|
   user = User.find_by_login(login)
   date_transaction = hash[:date_transaction].split(":")
   Factory :transaction,
           :date_transaction => DateTime.new(date_transaction[0].to_i, date_transaction[1].to_i, date_transaction[2].to_i).to_time,
           :amount => hash["amount"],
           :kind_transaction => "assorted_track",
           :user_id => user.id,
           :type_payment => hash["type_payment"],
           :type_transaction => hash["type_transaction"],
           :gateway => hash[:gateway]
  end
end

