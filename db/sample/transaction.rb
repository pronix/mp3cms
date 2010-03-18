require "populator"
require "faker"
debit_method = Profit.debit.map(&:code) - ["referrer_bonus"]
credit_method = Profit.credit.map(&:code) - ["referrer_bonus"]

Transaction.populate 100 do |tr|
  t_tr = [Transaction::CREDIT,Transaction::DEBIT ].rand
  tr.date_transaction = Time.local((rand * (5)).ceil + (Time.now.year - 5), (rand * 12).ceil, (rand * 31).ceil)
  tr.user_id = User.all.map(&:id).rand
  tr.type_transaction = t_tr
  tr.type_payment = Transaction::INTERNAL
  tr.kind_transaction = (tr == Transaction::CREDIT ? credit_method : debit_method ).rand
  tr.amount = [0.1, 0.2, 0.01, 0.5, 0.02].rand
end




