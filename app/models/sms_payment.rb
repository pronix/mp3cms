# Учет смс сообщений отправленных пользователям на пополнение баланса
class SmsPayment < ActiveRecord::Base
  # Associations
  belongs_to :user

  # Validations
  validates :msgid, :code, :presence => true
  validates_uniqueness_of :code
  before_validation :generate_code, :on => :create

  include AASM
  aasm_column :status
  aasm_initial_state :open

  aasm_state :open                                 # новое сообщение

  aasm_state :delivered                            # доставлено ответное сообщение
  aasm_state :rejected, :enter => :nil_code        # пользователь отказался от оплаты
  aasm_state :failed,   :enter => :nil_code        # сообщение не было доставлено;
  aasm_state :fraud,    :enter => :nil_code        # отмена транзакции по сообщению

  aasm_state :paid, :enter => :refill_balance      #  сообщение оплачено и баланс пополнен


  aasm_event :pay do # сообщение оплачено
    transitions :to => :paid, :from => :delivered
  end
  aasm_event :deliver do # ответное сообщение доставлено
    transitions :to => :delivered, :from => :open
  end

  aasm_event :reject do # пользователь отказался от оплаты
    transitions :to => :rejected, :from => :open
  end

  aasm_event :fail do # сообщение не было доставлено;
    transitions :to => :failed, :from => :open
  end

  aasm_event :deceived do # попытка мошенничество
    transitions :to => :fraud, :from => :open
  end

  # ------------------------------------------------------------------------------------------
  # Пользователь вводит пароль и сообщение переходит в оплачено
  # и пополняем баланс пользователя
  def refill_balance
    user.transactions.refill_balance_over_mobilcent(self.cost_usd).complete!
    save
  end

  # При всех отменах мы не производим удаление а только устанавливаем соответсвующий статус сообщения и обнуляем пароль
  # Пароль обнуляем что можно было использовать пароли в других сообщениях
  def nil_code
    self.code = nill
    save
  end

  # Генерируем пароль для смс
  def generate_code
    @_code =  Array.new(6/2) { rand(256) }.pack('C*').unpack('H*').first.upcase
    while self.class.count(:conditions  => { :code => @_code }) != 0
      @_code =  Array.new(6/2) { rand(256) }.pack('C*').unpack('H*').first.upcase
    end
    self.reply_message = "MP3CMS: password #{@_code}"
    self.code = @_code
  end
end
