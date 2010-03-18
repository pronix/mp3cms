Given /^есть следующие транзакции в сервиса:$/ do |table|
  Transaction.destroy_all
  table.hashes.each do |hash|
    Factory(:transaction,
            :date_transaction => Time.parse(hash["date_transaction"]).to_s,
            :user => User.find_by_email(hash['user'].strip),
            :type_transaction => "Transaction::#{hash["type_transaction"].strip.upcase}".constantize,
            :kind_transaction => hash["kind_transaction"].strip,
            :type_payment => "Transaction::#{hash["type_payment"].strip.upcase}".constantize,
            :amount => hash["amount"],
            :status => "success"

            )
  end
end
# When /^I delete the (\d+)(?:st|nd|rd|th) payments$/ do |pos|
#   visit payments_url
#   within("table tr:nth-child(#{pos.to_i+1})") do
#     click_link "Destroy"
#   end
# end


