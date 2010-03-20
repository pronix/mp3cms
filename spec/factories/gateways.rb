Factory.define :webmoney, :class => Gateway::Webmoney do |gw|

  gw.name 'Webmoney'
  gw.description 'Webmoney'
  gw.active true
  gw.secret  "cfvsq[bnhsqgfhjkm"
  gw.wmid  "329080303191"
  gw.payee_purse  "Z351277807459"
  gw.url 'https://merchant.webmoney.ru/lmi/payment.asp'
end
