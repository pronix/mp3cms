class Transaction < ActiveRecord::Base
  CREDIT   = 1
  DEBIT    = 2
  INTERNAL = 1
  FOREIGN  = 2

  belongs_to :user

  # Validations
  validates_presence_of :user_id, :type_payment, :amount, :type_transaction, :kind_transaction

  validates_inclusion_of :type_transaction, :in => [CREDIT, DEBIT]
  validates_inclusion_of :kind_transaction, :in => Profit.all.map(&:code)
  validates_inclusion_of :type_payment, :in => [INTERNAL, FOREIGN]

  validate :can_buy, :if => lambda{ |t| t.debit? }
  validates_numericality_of :amount, :on => :create

  # named_scope
  named_scope :debits, :conditions => { :type_transaction => DEBIT }
  named_scope :credits, :conditions => { :type_transaction => CREDIT }
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

end
