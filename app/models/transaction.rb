class Transaction < ActiveRecord::Base
  CREDIT   = 1
  DEBIT    = 2
  INTERNAL = 1
  FOREIGN  = 2

  belongs_to :user

  # Validations
  validates_presence_of :user_id, :type_payment, :amount, :type_transaction, :kind_transaction

  validates_inclusion_of :type_transaction, :in => [CREDIT, DEBIT]
  validates_inclusion_of :type_payment, :in => [INTERNAL, FOREIGN]

  validate :can_buy, :if => lambda{ |t| t.debit? }
  validate :check_kind_transaction
  validates_numericality_of :amount, :on => :create

  # Sphinx indexes
  define_index do
    indexes date_transaction, :sortable => true
    indexes type_payment
    indexes type_transaction
    indexes last_login_ip
    indexes current_login_ip
    set_property :delta => true, :threshold => Settings[:delta_index]
  end

  # named_scope
  default_scope :order => "date_transaction"
  named_scope :debits, :conditions => { :type_transaction => DEBIT }
  named_scope :credits, :conditions => { :type_transaction => CREDIT }
  named_scope :group_debits,
              :select => "kind_transaction, sum(amount) as amount,
                          date_trunc('day',date_transaction) as date_transaction",
              :conditions => { :type_transaction => DEBIT },
              :group => "date_transaction, kind_transaction"


  after_create :change_balance
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

  def debit?; self.type_transaction == DEBIT; end
  def credit?; self.type_transaction == CREDIT;  end
  def can_buy
    errors.add_to_base("Недостаточно денег") unless self.amount < user.balance
  end
  def check_kind_transaction
    errors.add(:kind_transaction, :inclusion) unless Profit.all.map(&:code).include?(self.kind_transaction)
  end
end

