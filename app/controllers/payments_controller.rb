=begin rdoc
Показываем пользователю
 Доход
 Расход
 Выплаты
И возможность пополнить баланс и подать заяку на выплату
=end

class PaymentsController < ApplicationController
  before_filter :require_user
  # filter_access_to :all, :attribute_check => false

  def show
    @kind_transactions = { }
    Profit.all.map{ |x| @kind_transactions[x.code] = x.name }
    @credits = current_user.transactions.credits
    @debits = current_user.transactions.debits
  end
end
