class WebmoneyController < ApplicationController
  before_filter :require_user, :only => [:pay, :show]
  skip_before_filter :verify_authenticity_token
  filter_access_to [:show, :pay], :attribute_check => false

  before_filter :allowed_to_use
  before_filter :parse_payment_params, :only => [:result, :success, :fail]
  before_filter :valid_payment, :only => [:result]

  def show
    respond_to do |format|
      format.html { }
      format.js { render :action => :show, :layout => false }
    end
  end

  # Проверяем что сума являеться числом и создаем оркрытую транзакцию
  def pay
    respond_to do |format|
      if (@invoice = current_user.transactions.refill_balance_over_webmoney((params[:pay][:amount].to_f rescue 0))) && @invoice.valid?
        format.html{ }
        format.js{ render :action => "pay", :layout => false }
      else
        format.html{ render :action => "show" }
        format.js{ render :action => "show", :layout => false }
      end
    end
  end

  # Результат платежа
  # Получаем данные об оплате, проверяем их,
  # записываем данные платежа в транзакцию и закрываем оплаченную транзакцию
  def result
    @transaction =  Transaction.open.find @payment_params[:payment_no]
    if @transaction.complete!
      render :text => "Success"
    else
      render :text => "No"
    end
  end

  # Подтвержение успешной оплаты
  # Проверяем что нужная транзакция уже закрыта и проведена
  def success
    if (@transaction =  Transaction.success.find @payment_params[:payment_no])
      flash[:notice] = I18n.t('webmoney.flash.success_payment', :default => "Success")
      redirect_to payments_url
    else
      render :text => I18n.t('webmoney.flash.fail_payment', :default => "Fail")
    end
  end

  # Платеж отменен
  # закрываем транзакцию со статусом error (не удачное завершение транзакции)
  def fail
    if (@transaction =  Transaction.open.find @payment_params[:payment_no])
      @transaction.destroy
    end

    flash[:notice] = I18n.t('webmoney.flash.canceled_payment', :default => "Cancel")
    redirect_to payments_url

  end


  private
  # Проверяем что шлюз включен
  def allowed_to_use
    @gateway = Gateway.webmoney
    begin
      flash[:notice] =  I18n.t("Gateway is not supported")
      redirect_to payments_url
    end unless @gateway.active?
  end

  # разбираем параметры
  def parse_payment_params
    @payment_params = HashWithIndifferentAccess.new
    params.each do |key, value|
      if key.starts_with?('LMI_')
        @payment_params[key.gsub(/^LMI_/, "").downcase] = value
      end
    end
  end

  # Проверяем верен ли платеж
  def valid_payment
    if @payment_params[:prerequest] == "1" # предварительный запрос
      render :text => "YES"
    elsif  @gateway.secret.blank?  # если не указан секретный ключ
      render :text => "WebMoney secret key is not provided"
    elsif ! @payment_params[:hash] ==  # если мд5 не совпает
        Digest::MD5.hexdigest([
                               @payment_params[:payee_purse],    @payment_params[:payment_amount],
                               @payment_params[:payment_no],     @payment_params[:mode],
                               @payment_params[:sys_invs_no],    @payment_params[:sys_trans_no],
                               @payment_params[:sys_trans_date], @gateway.secret,
                               @payment_params[:payer_purse],    @payment_params[:payer_wm]
                              ].join("")).upcase

      render :text => "not valid payment"
    end

  end

end
