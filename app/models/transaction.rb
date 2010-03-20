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
    indexes type_payment
    indexes type_transaction
    indexes amount
    has amount, date_transaction
    has transaction.user :as => "user"
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


  def self.search_transaction(query)

    start_date = Date.new(query[:transaction]["start_transaction(1i)"].to_i, query[:transaction]["start_transaction(2i)"].to_i, query[:transaction]["start_transaction(3i)"].to_i)
    end_date = Date.new(query[:transaction]["end_transaction(1i)"].to_i, query[:transaction]["end_transaction(2i)"].to_i, query[:transaction]["end_transaction(3i)"].to_i)

    case query[:attribute]
      when "type_transaction"
        self.search :conditions => { :type_transaction => query[:transaction][:select_type_transaction], :date_transaction => start_date.to_time..end_date.to_time }
      when "webmoney_purs"
        case query[:webmoney_purs]
          when "more"
            self.search :with => { :date_transaction => start_date.to_time..end_date.to_time, :amount => query[:search_transaction].to_f..99999.to_f }
          when "less"
            self.search :with => { :date_transaction => start_date.to_time..end_date.to_time, :amount => 99999.to_f..query[:search_transaction].to_f }
          when "well"
            self.search :conditions => { :amount => query[:search_transaction], :date_transaction => start_date.to_time..end_date.to_time }
        end
      when "type_payment"
        self.search :conditions => { :type_payment => query[:transaction][:select_type_payment] }
    else

    end

  end

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

