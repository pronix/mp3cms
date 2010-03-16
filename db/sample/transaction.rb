debit_method = Profit.debit.map(&:code) - ["referrer_bonus"]
credit_method = Profit.credit.map(&:code) - ["referrer_bonus"]

User.all.each do |u|
  u.balance = 10
  u.save
  u.reload
  20.times {
    d_method = debit_method.rand
    u.send("debit_#{d_method}",Profit.find_by_code(d_method).name )
    t = u.transactions.last
    t.date_transaction = Time.local((rand * (5)).ceil + (Time.now.year - 5), (rand * 12).ceil, (rand * 31).ceil)
    t.save
    c_method = credit_method.rand
    u.send("credit_#{c_method}",Profit.find_by_code(c_method).name )
    t = u.transactions.last
    t.date_transaction = Time.local((rand * (5)).ceil + (Time.now.year - 5), (rand * 12).ceil, (rand * 31).ceil)
    t.save
  }
end



