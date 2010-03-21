Factory.define :profit do |u|
end
Factory.define :profit_credit, :parent => :profit do |u|
  u.percentage false
  u.type_transaction "credit"
end
Factory.define :profit_debit, :parent => :profit do |u|
  u.percentage false
  u.type_transaction "debit"
end

Factory.define :upload_track, :parent => :profit_credit do |u|
  u.name "Аплоад файла (после апрува)"
  u.code "upload_track"
  u.amount 0.1
end

Factory.define :find_track, :parent => :profit_credit do |u|
  u.name "Находка мп3 (модуль заказов)"
  u.code "find_track"
  u.amount 0.01
end

Factory.define :add_news, :parent => :profit_credit do |u|
  u.name "Добавление новости (после апрува)"
  u.code "add_news"
  u.amount 0.02
end
Factory.define :refferer_bonus, :parent => :profit_credit do |u|
  u.name "Доход от суммы потраченной на сайте рефералом %"
  u.code "referrer_bonus"
  u.amount 40
  u.percentage true
end

Factory.define :download_track, :parent => :profit_debit do |u|
  u.name "Скачивание mp3 файла"
  u.code "download_track"
  u.amount 0.02
end

Factory.define :order_track, :parent => :profit_debit do |u|
  u.name "Заказ mp3"
  u.code "order_track"
  u.amount 0.02
end

Factory.define :assorted_track, :parent => :profit_debit do |u|
  u.name "Нарезка файла (после клика на скачивание)"
  u.code "assorted_track"
  u.amount 0.01
end
Factory.define :min_amount_payout, :parent => :profit do |u|
  u.name "Минимальная сумма для выплаты"
  u.code "min_amount_payout"
  u.amount 10
  u.percentage false
  u.type_transaction "parametr"
end



