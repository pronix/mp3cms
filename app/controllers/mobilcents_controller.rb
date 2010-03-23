=begin rdoc
Пополнение баланса через MobilCents
=end
class MobilcentsController < ApplicationController
  before_filter :require_user, :only => [:show, :pay]
  skip_before_filter :verify_authenticity_token
  filter_access_to [:show, :pay], :attribute_check => false

  before_filter :get_gateway   # получаем шлюз


  # Показываем форму с информации для оплаты и полем ввода пароля.
  def show
    respond_to do |format|
      format.html { }
      format.js { render :action => :show, :layout => false }
    end
  end

  # Пользователь вводит пароль полученный в ответном смс и мы пополняем ему баланса
  def pay
    @sms_payment = params[:sms] && params[:sms][:code] && SmsPayment.delivered.find_by_code(params[:sms][:code])
    if @sms_payment && ( @sms_payment.user = current_user ) && @sms_payment.pay!
      flash[:notice] = 'Successfully'
      redirect_to payments_path
    else
      flash[:error] = 'invalid password'
      respond_to do |format|
        format.html { }
        format.js { render :action => :show, :layout => false }
      end
    end
  end

  # После того как пользователь отправил смс, на result  приходить запрос что смс отправлена,
  # в ответ мы формируем пароль и отправляем пользователя.
  def result
    @secret_code = @gateway.secret_code
    if params[:sign] == Digest::MD5.hexdigest([
                          @secret_code, params[:country], params[:shortcode],
                          params[:provider], params[:prefix], params[:cost_local],
                          params[:cost_usd], params[:phone], params[:msgid],
                          params[:sid], params[:content] ].join('::'))

      @sms_payment = SmsPayment.create!({
         :country  => params[:country],  :shortcode  => params[:shortcode],
         :provider => params[:profix],   :cost_local => params[:cost_local],
         :cost_usd => params[:cost_usd], :phone      => params[:phone],
         :msgid    => params[:msgid],    :sid        => params[:sid],
         :content  => params[:content]     })

      # отправляем сообщение которое будет показано пользователю
      render :text => @sms_payment.reply_message.to_s, :status => :ok
    else
      render :text => "not valid "
    end
  end

  # Проверка того что оплата произведена или отменена
  def status
    @secret_code = @gateway.secret_code
    if params[:sign] == Digest::MD5.hexdigest([@secret_code,params[:msgid],
                                               params[:phone],params[:status]].join('::'))
      @sms_payment = SmsPayment.open.find_by_msgid params[:msgid]
      @sms_payment.sms_status = params[:status]

      case params[:status]
      when /delivered/i                        # сообщение было доставлено
        @sms_payment.deliver!
      when /rejected/i  	                     # оплата была отклонена пользователем
        @sms_payment.reject!
      when /[fraud|unconfirmed|timeout]/i      # необходимо отменить уже проведенную транзакцию
        @sms_payment.deceived!
      else                                     # сообщение не было доставлено
        @sms_payment.fail!
      end

    else
      render :text => "not valid "
    end
  end

  private

  def get_gateway
    @gateway = Gateway.mobilcents
  end

end
