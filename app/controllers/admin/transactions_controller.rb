class Admin::TransactionsController < Admin::ApplicationController
  filter_access_to :all, :attribute_check => false

  def index
    @kind_transactions = { }
    Profit.all.map{ |x| @kind_transactions[x.code] = x.name }
    @kind_transactions[Transaction::REFILL_BALANCE_WEBMONEY] =  I18n.t("payments.refill_balance_webmoney")
    @kind_transactions[Transaction::REFILL_BALANCE_SMS] =       I18n.t("payments.refill_balance_sms")
    @kind_transactions[Transaction::WITHDRAW] =                 I18n.t("payments.withdraw")

    @trans = Transaction.all
  end

end
