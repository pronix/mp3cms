class Profit < ActiveRecord::Base
  CREDIT = "credit"
  DEBIT = "debit"
  PARAMETR = "parametr"
  # Validations
  validates_presence_of :name, :code, :amount, :type_transaction
  validates_numericality_of :amount
  validates_inclusion_of :type_transaction, :in => [CREDIT, DEBIT, PARAMETR]

  # scope
  default_scope :order => "type_transaction, amount"
  scope :credit,   where( :type_transaction => CREDIT)
  scope :debit,    where( :type_transaction => DEBIT)
  scope :parametr, where( :type_transaction => PARAMETR)
  scope :witout_parametr, where(:type_transaction => [DEBIT, CREDIT] )

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
