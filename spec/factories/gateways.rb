Factory.define :webmoney, :class => Gateway::Webmoney do |gw|
  gw.name 'Webmoney'
  gw.description 'Webmoney'
  gw.active true
  gw.secret  "cfvsq[bnhsqgfhjkm"
  gw.wmid  "329080303191"
  gw.payee_purse  "Z351277807459"
  gw.url 'https://merchant.webmoney.ru/lmi/payment.asp'
end

Factory.define :mobilcents, :class => Gateway::Mobilcents do |gw|
  gw.name 'Mobilcents'
  gw.description 'MobilCents'
  gw.active true
  gw.sms true
  gw.mobilgate_id 10229
  gw.xml_url "http://engine.mobilcent.com/xml/gate/?/all"
  gw.secret_code "cfvsq[bnhsqgfhjkm"
end

Factory.define :cost_country_ru, :class => CostCountry  do |c|
  c.code  "RU"
  c.country "Россия"
  c.cost  230
end
Factory.define :cost_country_sk, :class => CostCountry  do |c|
  c.code  "SK"
  c.country "Словакия"
end
