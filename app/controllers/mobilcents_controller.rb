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

    # Формируем список тарифов
    cost_countries = CostCountry.all.map { |x| [x.code, x.cost]}
    @_price_sms = @gateway.tariffs

    # Для стран с определенной стоимостью смс, убираем лишние тарифы
    @price_sms ={ }
    @_price_sms.each do |country, pr_sms|
      cost_country = cost_countries.find{|n| n.first == country.to_s }.try(:last).to_i
      @price_sms[country.to_sym] = pr_sms

      unless cost_country == 0
        pr_sms[:providers].each do |provider, v|
          end_cost = v[:sms_price].map{|n| n[:usd].to_f }.map {|m| [(cost_country-m).abs, m] }.min.last
          @price_sms[country][:providers][provider][:sms_price] = @price_sms[country][:providers][provider][:sms_price].
            select{|n| n[:usd].to_f == end_cost }
        end
      end
    end


    respond_to do |format|
      format.html { }
      format.js { render :action => :show, :layout => false }
    end
  end


  # Пользователь вводит пароль полученный в ответном смс и мы пополняем ему баланса
  def pay
    @sms_payment = params[:sms] && params[:sms][:code] && SmsPayment.delivered.find_by_code(params[:sms][:code])


      if @sms_payment && ( @sms_payment.user = current_user ) && @sms_payment.pay!
        flash[:notice] = 'Платеж принят'
        redirect_to payments_path, :notice => 'Платеж принят'
      else
        flash[:error] = 'invalid password'
        respond_to do |format|
        format.html {  redirect_to(:action => "show")  }
        format.js { render :text => 'invalid password', :status => :internal_server_error }
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
      @sms_payment.deliver! if params[:billing][/MO/i]

      # отправляем сообщение которое будет показано пользователю
      render :text => @sms_payment.reply_message.to_s, :status => :ok and return
    else
      render :text => "not valid " and return
    end
  end

  # Проверка того что оплата произведена или отменена
  def status_pay
    @secret_code = @gateway.secret_code
    if params[:sign] == Digest::MD5.hexdigest([@secret_code,params[:msgid], params[:phone],params[:status]].join('::'))
      @sms_payment = SmsPayment.open.find_by_msgid params[:msgid]
      @sms_payment.sms_status = params[:status]

      case params[:status]
      when /delivered/i                        # сообщение было доставлено
        @sms_payment.deliver!
      when /rejected/i  	                     # оплата была отклонена пользователем
        @sms_payment.reject!
      when /fraud|unconfirmed|timeout/i      # необходимо отменить уже проведенную транзакцию
        @sms_payment.deceived!
      else                                     # сообщение не было доставлено
        @sms_payment.fail!
      end
      @return_text = "ok!"
    else
      @return_text = "not valid"
    end
    render( :text => @return_text ) and return
  end

  private

  def get_gateway
    @gateway = Gateway.mobilcents
  end

end

