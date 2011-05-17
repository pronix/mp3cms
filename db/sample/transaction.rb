require "populator"
require "faker"
debit_method = Profit.debit.map(&:code) - ["referrer_bonus"]
credit_method = Profit.credit.map(&:code) - ["referrer_bonus"]

100.times do |tr|
  t_tr = [Transaction::CREDIT,Transaction::DEBIT ].sample
  Transaction.create!({
                        :date_transaction => Time.local((rand * (5)).ceil + (Time.now.year - 5),
                                                        (rand * 12).ceil, (rand * 31).ceil),
                        :user_id => User.offset(rand(User.count)).first.try(:id),
                        :type_transaction => t_tr,
                        :type_payment => Transaction::INTERNAL,
                        :kind_transaction => (t_tr == Transaction::CREDIT ? credit_method : debit_method ).sample,
                        :amount => [0.1, 0.2, 0.01, 0.5, 0.02].sample,
                        :status => "success",
                        :delta => true,
                      })
end




