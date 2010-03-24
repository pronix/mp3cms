def user_orders(user_login)
  user = User.find_by_login(user_login)
  orders = Order.find(:all, :conditions => {:user_id => user.id})
  return orders
end

То /^есть следующие заказы:$/ do |table|
  table.hashes.each do |hash|
    user = User.find_by_email(hash["user_email"])
    order = Factory(:order,
            :user_id => user.id,
            :title => hash["Название"],
            :author => hash["Исполнитель"])
    order.to_found if hash["Статус"] == "Найдено"
    order.save
  end
end

То /^я увижу следующие заказы:$/ do |table|
  table.hashes.each_with_index do |hash, index|
    И %(я увижу "#{hash["Исполнитель"]}" в "#orders #order_#{index+1}_author")
    И %(я увижу "#{hash["Название"]}" в "#orders #order_#{index+1}_title")
    И %(я увижу "#{hash["Статус"]}" в "#orders #order_#{index+1}_state")
    И %(я увижу "#{hash["Заказал"]}" в "#orders #order_#{index+1}_user")
  end
end

Если /^мне (разреш\w+|запре\w+) просмотр списка заказов$/ do |permission|
  visit orders_path
  То "мне #{permission} доступ"
end

Если /^мне (разреш\w+|запре\w+) просмотр заказов$/ do |permission|
  order = Order.first
  visit order_path(order)
  То "мне #{permission} доступ"
end

Если /^мне (разреш\w+|запре\w+) создание заказов$/ do |permission|
  visit new_order_path
  Then "мне #{permission} доступ"
  post orders_path, {}
  Then "мне #{permission} доступ"
end

Если /^мне (разреш\w+|запре\w+) редактирование заказов$/ do |permission|
  for order in Order.all
    visit edit_order_path(order)
    То "мне #{permission} доступ"
    put order_path(order), {}
    То "мне #{permission} доступ"
  end
end

Если /^мне (разреш\w+|запре\w+) редактирование заказов пользователя "([^\"]*)"$/ do |permission, login|
  user_orders(login).each do |order|
    visit edit_order_path(order)
    То "мне #{permission} доступ"
    put order_path(order), {}
    То "мне #{permission} доступ"
  end
end

Если /^мне (разреш\w+|запре\w+) удаление заказов$/ do |permission|
  for order in Order.all
    delete order_path(order)
    То "мне #{permission} доступ"
  end
end

Если /^мне (разреш\w+|запре\w+) удаление заказов пользователя "([^\"]*)"$/ do |permission, login|
  user_orders(login).each do |order|
    delete order_path(order)
    То "мне #{permission} доступ"
  end
end

То /^мне (разреш\w+|запре\w+) создание заявок на заказы$/ do |permission|
  for order in Order.all
    visit new_order_tender_path(order)
    #И %(покажи страницу)
    Then "мне #{permission} доступ"
  end
end

То /^мне (разреш\w+|запре\w+) (подтвержд\w+|отклонен\w+) заявок на заказы(?:| пользователя "([^\"]*)")$/ do |permission, found_notfound, login|
  tender = Tender.first
  if login
    orders = user_orders(login)
  else
    orders = Order.all
  end
  for order in orders
    if found_notfound =~ /подтвержд/
      visit found_order_path(order, :tender_id => tender.id)
      Then "мне #{permission} доступ"
    else
      visit notfound_order_path(order, :tender_id => tender.id)
      Then "мне #{permission} доступ"
    end
  end
end

