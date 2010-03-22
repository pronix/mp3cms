class CreateSmsPayments < ActiveRecord::Migration
  def self.up
    create_table :sms_payments do |t|
      t.integer :user_id                   # пользователь
      t.string  :status                    # статус сообщения
      t.string  :country                   # Двухбуквенный код страны.
      t.string  :shortcode  # int	Номер, на который было отправлено сообщение.
      t.string  :provider   # cha r()(16)	Использовавшийся оператор сотовой связи (в случае, если эта информация релевантна).
      t.string  :prefix     # cha r()(16)	Префикс полученного сообщения.

      t.float   :cost_local # float	Стоимость полученного сообщения в местных денежных единицах.
      t.float   :cost_usd   # float	Стоимость полученного сообщения в USD.

      t.string  :phone      # cha r()(32)	Номер, с которого было отправлено сообщение, включая код страны;
                            # для некоторых стран вместо актуального номера передается некий уникальный идентификатор абонента
                            # в системе.
      t.string  :msgid      # cha r()(32)	Уникальный идентификатор сообщения.
      t.string  :sid        # int	Идентификатор используемого сервиса в нашей системе.
      t.string  :content    # cha r()(128)	Текст сообщения.
      t.string  :sms_status     # статус сообщения
                            # delivered - сообщение доставлено и оплачено;
                            # rejected - пользователь отказался от оплаты;
                            # failed - сообщение не было доставлено;
                            # fraud - оплата сообщения не подтверждена или была отменена;
                            # как правило, это происходит в результате попыток мошенничества со стороны абонента
                            # либо в результате нарушения пользовательского соглашения владельцем сервиса.
                            # Подразумевается, что этот статус может быть присвоен сообщению в том числе и
                            # после подтверждения об успешной оплате.

      t.string :code        # код который будем отправлять пользователю
      t.string :reply_message # сообщение которое было отправлено
      t.timestamps
    end

    add_index :sms_payments, :msgid
    add_index :sms_payments, :status
  end

  def self.down
    remove_index :sms_payments, :msgid
    remove_index :sms_payments, :status
    drop_table :sms_payments
  end
end
