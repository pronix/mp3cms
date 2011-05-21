class Transaction < ActiveRecord::Base
  CREDIT   = 1
  DEBIT    = 2
  INTERNAL = 1
  FOREIGN  = 2
  GATEWAY_WEBMONEY = 'webmoney'
  GATEWAY_MOBILCENT = 'mobilecent'
  REFILL_BALANCE_WEBMONEY = 'refill_balance_webmoney'
  REFILL_BALANCE_SMS = 'refill_balance_sms'
  WITHDRAW = 'withdraw'

  include AASM
  aasm_column :status
  aasm_initial_state lambda{ |t| t.type_payment == FOREIGN ? :open : :internal   }

  aasm_state :open
  aasm_state :internal
  aasm_state :success, :enter => :change_balance
  aasm_event :complete do
    transitions :to => :success, :from => [:open, :internal]
  end

  belongs_to :user

  delegate :login, :to => :user, :prefix => true, :allow_nil => true

  # Validations
  validates_presence_of :user_id, :type_payment, :amount, :type_transaction, :kind_transaction

  validates_inclusion_of :type_transaction, :in => [CREDIT, DEBIT]
  validates_inclusion_of :type_payment,     :in => [INTERNAL, FOREIGN]
  validates_inclusion_of :gateway,          :in => [GATEWAY_MOBILCENT, GATEWAY_WEBMONEY],
                                            :if => lambda{ |t| t.type_payment == FOREIGN }

  validate :can_buy, :if => lambda{ |t| t.debit? }
  validate :check_kind_transaction
  validates_numericality_of :amount, :on => :create, :greater_than_or_equal_to => 0, :less_than => 10000

  # Sphinx indexes
  define_index do
    indexes type_payment
    indexes type_transaction
    has amount, date_transaction
    indexes user.login, :as => :user
    set_property :delta => true, :threshold => Settings.delta_index
  end

  # Нужно для дельта sphinx
  #
  def user_login_changed?
    true
  end
  # scope
  default_scope :order => "date_transaction"
  scope :debits, where("transactions.type_transaction = :type_tr AND
                        status = 'success'
                        AND NOT( transactions.kind_transaction = :kind_tr )",
                       :type_tr => DEBIT, :kind_tr =>  WITHDRAW).order("transactions.kind_transaction")
  scope :credits, where("transactions.type_transaction = :type_tr
                         AND status = 'success'
                         AND NOT( transactions.kind_transaction = :kind_tr )", :type_tr => CREDIT, :kind_tr => WITHDRAW)

  scope :withdraws, where( :kind_transaction => WITHDRAW )

  scope :group_debits, select("kind_transaction, sum(amount) as amount, date_trunc('day',date_transaction) as date_transaction").
                       where(:type_transaction => DEBIT).
                       group("date_transaction, kind_transaction")

  # транзакции за скачивание треков
  scope :download_track, where(:kind_transaction => "download_track", :type_transaction => DEBIT)

  def self.search_transaction(query, per_page)
    start_date = Date.new(query[:transaction]["start_transaction(1i)"].to_i,
                          query[:transaction]["start_transaction(2i)"].to_i,
                          query[:transaction]["start_transaction(3i)"].to_i)
    end_date = Date.new(query[:transaction]["end_transaction(1i)"].to_i,
                        query[:transaction]["end_transaction(2i)"].to_i,
                        query[:transaction]["end_transaction(3i)"].to_i)

    case query[:attribute]
    when "type_transaction"
      self.search :conditions => { :type_transaction => query[:transaction][:select_type_transaction] },
                  :with => { :date_transaction => start_date.to_time..end_date.to_time },
                  :per_page => per_page, :page => query[:page]
    when "webmoney_purs"
      case query[:webmoney_purs]
      when "more"
        self.search :with => { :date_transaction => start_date.to_time..end_date.to_time,
                               :amount => query[:q].to_f..99999.to_f },
                    :per_page => per_page, :page => query[:page]
      when "less"
        self.search :with => { :date_transaction => start_date.to_time..end_date.to_time,
                               :amount => -99999.to_f..query[:q].to_f },
                    :per_page => per_page, :page => query[:page]
      when "well"
        self.search :with => { :amount => query[:q].to_f..query[:q].to_f,
                               :date_transaction => start_date.to_time..end_date.to_time },
                    :per_page => per_page, :page => query[:page]
      end
    when "type_payment"
      self.search :conditions => { :type_payment => query[:transaction][:select_type_payment] },
                  :with => {:date_transaction => start_date.to_time..end_date.to_time},
                  :per_page => per_page, :page => query[:page]
    when "login"
      self.search :conditions => { :user => query[:q] },
                  :with => {:date_transaction => start_date.to_time..end_date.to_time},
                  :per_page => per_page, :page => query[:page]
    else
      []
    end

  end

  # after_create :change_balance

  def change_balance
    user.transaction do
      if credit?
        user.balance = (user.balance || 0) + self.amount
      elsif debit?
        user.balance = (user.balance || 0) - self.amount if user.can_buy(self.amount)
        # Если происходит вывод денег то записываем эту сумму в общую сумму выводимую пользователем
        user.total_withdrawal = (user.total_withdrawal || 0) + self.amount if self.kind_transaction == WITHDRAW
      end
      user.save
    end
  end

  def refill_balance?
    REFILL_BALANCE_SMS  == self.kind_transaction || REFILL_BALANCE_WEBMONEY  == self.kind_transaction
  end

  def debit?
    self.type_transaction == DEBIT
  end
  def credit?
    self.type_transaction == CREDIT
  end
  def can_buy
    errors.add_to_base("Недостаточно денег") unless self.amount <= user.balance
  end
  def check_kind_transaction
    errors.add(:kind_transaction, :inclusion) unless [Profit.all.map(&:code),
                                                      REFILL_BALANCE_WEBMONEY,
                                                      REFILL_BALANCE_SMS, WITHDRAW].flatten.include?(self.kind_transaction.to_s)
  end

  class << self
    # Массовое завершение выплаты
    def masspay_success!(withdraw_ids)
      @message = { :error => [], :notice => []}
      @widthdraws = find(withdraw_ids)

      @widthdraws.each do |wd|
        if wd.user.can_buy(wd.amount)
          wd.complete!
        else
          @message[:error] << "По заявке №#{wd.id} (#{wd.date_transaction}) не хватает денег "
        end
      end

      @message[:notice] << "Заявки на выплату завершены." if @message[:error].blank?
      return @message
    rescue ActiveRecord::RecordNotFound
      @message[:error] << "Зявки на вывод не найдены"
      return @message
    end
  end
end

