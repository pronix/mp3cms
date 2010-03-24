=begin rdoc
Показываем пользователю
 Доход
 Расход
 Выплаты
И возможность пополнить баланс и подать заяку на выплату
=end

class PaymentsController < ApplicationController
  before_filter :require_user
  filter_access_to :all, :attribute_check => false

  def show
    @kind_transactions = { }
    Profit.all.map{ |x| @kind_transactions[x.code] = x.name }
    @kind_transactions[Transaction::REFILL_BALANCE_WEBMONEY] =  I18n.t("payments.refill_balance_webmoney")
    @kind_transactions[Transaction::REFILL_BALANCE_SMS] =       I18n.t("payments.refill_balance_sms")
    @kind_transactions[Transaction::WITHDRAW] =                 I18n.t("payments.withdraw")

    @credits = current_user.transactions.credits.group_by { |x| x.date_transaction.beginning_of_day }
    @debits  = current_user.transactions.debits.group_by  { |x| x.date_transaction.beginning_of_day }
    @withdraws = current_user.transactions.withdraws
    respond_to do |format|
      format.html{ }
      format.js {  render :action => "show", :layout => false }
    end
  end
end
