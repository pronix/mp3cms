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
           :type_transaction => hash["type_transaction"]
  end
end

