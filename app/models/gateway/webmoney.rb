class Gateway::Webmoney < Gateway

  preference :secret         # секретный ключ
  preference :wmid           # индентификатор продовца
  preference :payee_purse    # кошелек продовца
  preference :url,  :default => 'https://merchant.webmoney.ru/lmi/payment.asp',
                    :access_level => :protected

  validates_presence_of :secret, :wmid, :payee_purse
  validates_format_of   :payee_pursee, :with => /^Z[0-9]{12}/


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
  def masspay(claims, description = "MP3CMPS (webmoney) : masspay.")
    @accept_claims = []
    @error_claims  = []

    @xml = Nokogiri::XML::Builder.new {  |x|
      x.payments(:xmlns => "http://tempuri.org/ds.xsd") {
        claims.each do |cl|

          @u = cl.user
          if @u.claim_on_payouts.summa_claim <= @u.earned_money.to_f
            # по заявке хватает денег, создаем транзакцию и формируем часть xml

            @accept_claims << cl
            x.payment{
              x.destination  cl.purse_dest
              x.amount       cl.finite_sum
              x.description  PayoutPattern.match(description, cl).to_s

              x.id_ cl.id
            }

          else
            # по этой заявке нехватает денег
            @error_claims << cl
          end

        end

      }

    }

    return @xml.to_xml,
    { :type => 'text/xml; charset=utf-8; header=present',
      :filename => "masspay_webmoney_#{Time.now.strftime("%d_%m_%Y")}.xml" }


  end

end
