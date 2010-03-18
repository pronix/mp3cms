class Transaction < ActiveRecord::Base
  CREDIT   = 1
  DEBIT    = 2
  INTERNAL = 1
  FOREIGN  = 2
  GATEWAY_WEBMONEY = 'webmoney'
  GATEWAY_MOBILCENT = 'mobilecent'
  REFILL_BALANCE_WEBMONEY = 'refill_balance_webmoney'
  REFILL_BALANCE_SMS = 'refill_balance_sms'

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

  # Validations
  validates_presence_of :user_id, :type_payment, :amount, :type_transaction, :kind_transaction

  validates_inclusion_of :type_transaction, :in => [CREDIT, DEBIT]
  validates_inclusion_of :type_payment, :in => [INTERNAL, FOREIGN]
  validates_inclusion_of :gateway, :in => [GATEWAY_MOBILCENT, GATEWAY_WEBMONEY],
                                   :if => lambda{ |t| t.type_payment == FOREIGN }

  validate :can_buy, :if => lambda{ |t| t.debit? }
  validate :check_kind_transaction
  validates_numericality_of :amount, :on => :create

  # named_scope
  default_scope :order => "date_transaction"
  named_scope :debits, :conditions => { :type_transaction => DEBIT, :status => 'success' }
  named_scope :credits, :conditions => { :type_transaction => CREDIT, :status => 'success' }
  named_scope :group_debits,
              :select => "kind_transaction, sum(amount) as amount,
                          date_trunc('day',date_transaction) as date_transaction",
              :conditions => { :type_transaction => DEBIT },
              :group => "date_transaction, kind_transaction"


  # after_create :change_balance
  def change_balance
    user.transaction do
      if credit?
        user.balance = (user.balance || 0) + self.amount
      elsif debit?
        user.balance = (user.balance || 0) - self.amount
      end
      user.save
    end
  end
  def refill_balance?
    REFILL_BALANCE_SMS  == self.kind_transaction ||
      REFILL_BALANCE_WEBMONEY  == self.kind_transaction
  end

  def debit?; self.type_transaction == DEBIT; end
  def credit?; self.type_transaction == CREDIT;  end
  def can_buy
    errors.add_to_base("Недостаточно денег") unless self.amount < user.balance
  end
  def check_kind_transaction
    errors.add(:kind_transaction, :inclusion) unless [Profit.all.map(&:code), REFILL_BALANCE_WEBMONEY, REFILL_BALANCE_SMS].flatten.include?(self.kind_transaction)
  end
end
