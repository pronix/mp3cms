class Tender < ActiveRecord::Base
  default_scope :order => "tenders.tender_state, tenders.created_at DESC"
  validates_presence_of :user_id, :order_id, :link
  scope :active, where("tenders.tender_state != 'moderation'")

  belongs_to :user
  belongs_to :order
  has_many :check_tenders

  include AASM
  aasm_column :tender_state
  aasm_initial_state :moderation
  aasm_state :moderation
  aasm_state :approved
  aasm_state :rejected

  aasm_event :approve do
    transitions :to => :approved, :from => :moderation
  end

  aasm_event :rejecte do
    transitions :to => :rejected, :from => :moderation
  end



  def state
    self.complete? ? "Подтверждено" : "Отклонено"
  end
end

