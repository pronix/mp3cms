class Tender < ActiveRecord::Base
  validates_presence_of :user_id, :order_id, :link
  validates_format_of :link, :with => /^http:\/\/#{Settings[:main_domain]}/
  belongs_to :user
  belongs_to :order

  def state
    self.complete? ? "Подтверждено" : "Отклонено"
  end

end

