class Gateway::Webmoney < Gateway

  preference :secret,      :access_level => :edit   # секретный ключ
  preference :wmid,        :access_level => :edit   # индентификатор продовца
  preference :payee_purse, :access_level => :edit    # кошелек продовца
  preference :url,  :default => 'https://merchant.webmoney.ru/lmi/payment.asp',
                    :access_level => :protected

  validates_presence_of :secret, :wmid, :payee_purse
  validates_format_of   :payee_purse, :with => /^Z[0-9]{12}/
  validates_format_of   :wmid, :with => /^[0-9]{12}/

  def provider_class
    self.class
  end

  # Проверка пользовательского ид при составление заявки на вывод денег
  # Если есть ошибки то записываем из в _errors (ActiveRecord::Errors)
  def valid_user_params _purse_dest, _errors
    _errors.add_on_blank("purse_dest") if _purse_dest.blank?
    unless _purse_dest.to_s =~ /^[Z][0-9]{12}/
      _errors.add("purse_dest", :invalid, :value => _purse_dest)
    end
  end


  # Массовые выплаты
  # Возвращаем xml и парметры файла
  def masspay(withdraw_ids, description = "MP3CMPS (webmoney) : masspay.")
    @withdraws = Transaction.find(withdraw_ids)
    @error_withdraw  = []

    @xml = Nokogiri::XML::Builder.new {  |x|
      x.payments(:xmlns => "http://tempuri.org/ds.xsd") {
        @withdraws.each do |wd|
          @u = wd.user
          if @u.can_buy(wd.amount)
            # по заявке хватает денег, создаем транзакцию и формируем часть xml
            x.payment {
              x.destination  @u.webmoney_purse
              x.amount       wd.amount
              x.description  description.to_s
              x.id_          wd.id
            }

          else
            # по этой заявке нехватает денег
            @error_withdraw  << "По заявке №#{wd.id} (#{wd.date_transaction}) не хватает денег "
          end

        end

      }

    }


    return @xml.to_xml,
    { :type => 'text/xml; charset=utf-8; header=present',
      :filename => "masspay_webmoney_#{Time.now.strftime("%d_%m_%Y")}.xml" },
    @error_withdraw

  end

end
