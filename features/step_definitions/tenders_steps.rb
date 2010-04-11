Если /^я введу в поле "([^\"]*)" ссылку на трек "([^\"]*)"$/ do |field, link|
  track = Track.find_by_title(link)
  И %(я введу в поле "#{field}" значение "#{track_url(track)}")
end

Если /^заявка для заказа "([^\"]*)" будет подтверждена$/ do |order|
  order = Order.find_by_title(order)
  tender = Tender.first
  tender.complete = true
  tender.save
  order.to_found
  order.save
end

То /^есть следующие заявки:$/ do |table|
  table.hashes.each do |hash|
    user = User.find_by_email(hash["user_email"])
    order = Order.find_by_title(hash["Заказ"])
    tender = Factory(:tender,
            :user_id => user.id,
            :order_id => order.id,
            :link => hash["Ссылка"])
    tender.complete = true if hash["Статус"] == "Подтверждено"
    tender.save
  end
end

То /^есть следующие тендеры:$/ do |table|
  table.hashes.each do |hash|
    user = User.find_by_email(hash["От пользователя"])
    order = Order.find_by_title(hash["Название ордера"])
    tender = order.tenders.create!(
            :user_id => user.id,
            :link => hash["Ccылка"],
            :order_id => hash["order_id"])
    tender.save
  end
end