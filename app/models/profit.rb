class Profit < ActiveRecord::Base
  CREDIT = "credit"
  DEBIT = "debit"
  PARAMETR = "parametr"
  # Validations
  validates_presence_of :name, :code, :amount, :type_transaction
  validates_numericality_of :amount
  validates_inclusion_of :type_transaction, :in => [CREDIT, DEBIT, PARAMETR]

  # named_scope
  default_scope :order => "type_transaction, amount"
  named_scope :credit, :conditions => { :type_transaction => CREDIT}
  named_scope :debit, :conditions => { :type_transaction => DEBIT}
  named_scope :parametr, :conditions => { :type_transaction => PARAMETR}
  named_scope :witout_parametr, :conditions => ["type_transaction in (?)" ,[DEBIT, CREDIT]]
  def credit?;  type_transaction == CREDIT;  end
  def debit?;  type_transaction == DEBIT;  end
  def parametr?;  type_transaction == PARAMETR;  end

  def cost
  _cost = case type_transaction
          when CREDIT
            amount
          when DEBIT
            amount*-1
          when PARAMETR
            amount
          end

  end

  class << self
    # Минимальная сумма для выплат
    def minimum_withdraw
      find_by_code("min_amount_payout").amount
    end
  end
end
