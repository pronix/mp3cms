Given /^есть следующие транзакции в сервиса:$/ do |table|
  Transaction.destroy_all
  table.hashes.each do |hash|
    options = {:date_transaction => Time.parse(hash["date_transaction"]).to_s,
      :user => User.find_by_email(hash['user'].strip),
      :type_transaction => "Transaction::#{hash["type_transaction"].strip.upcase}".constantize,
      :kind_transaction => hash["kind_transaction"].strip,
      :type_payment => "Transaction::#{hash["type_payment"].strip.upcase}".constantize,
      :amount => hash["amount"],
      :status => (hash["status"].blank? ? "success": hash["status"]),
      :gateway => hash["gateway"] }
    options[:id] = hash["id"] if hash["id"]
    Factory(:transaction,options )
  end
end

When /^(?:|я )не увижу ссылку "([^\"]*)"$/ do |link|
  response.should_not have_tag("a",  link)
end

Given /^прописаны параметры платежного шлюза "([^\"]*)"$/ do |gateway|
  Factory gateway.to_sym
end

Then /^увижу форму отправки на оплату через webmoney$/ do
  response.should have_tag("form[action=?]",  Gateway.webmoney.url)
end
Then /^у пользователя "([^\"]*)" должна быть открытая транзакция$/ do |email_user|
  user = User.find_by_email email_user
  tr = user.transactions.open.last
  tr.should_not be_nil
  tr.kind_transaction.should == Transaction::REFILL_BALANCE_WEBMONEY
end
Then /^у пользователя "([^\"]*)" должна быть открытая заявка на вывод денег$/ do |email_user|
  user = User.find_by_email email_user
  tr =   tr = user.transactions.open.withdraws.last
  tr.should_not be_nil
  tr.kind_transaction.should == Transaction::WITHDRAW

end

When /^изменим дату заявки на вывод денег пользователя "([^\"]*)" на "([^\"]*)"$/ do |email_user, new_date |
  user = User.find_by_email email_user
  tr =   tr = user.transactions.open.withdraws.last
  tr.should_not be_nil
  tr.date_transaction = Time.parse new_date
  tr.save!
end
Given /^транзакции в сервисе еще нет$/ do
  Transaction.destroy_all
end

Then /^я увижу табличные данные по выплатам:$/ do |_table|
  Then %(я увижу "Дата(.*)Тип операции(.*)Статус(.*)Сумма")
  And %(я увижу "Заказ выплаты(.*)В обработке(.*)10.00 руб.")
end
