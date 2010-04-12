class Tender < ActiveRecord::Base

  validates_presence_of :user_id, :order_id, :link

  belongs_to :user
  belongs_to :order
  has_many :check_tenders

  def state
    self.complete? ? "Подтверждено" : "Отклонено"
  end
  
end

