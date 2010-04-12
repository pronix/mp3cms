class CheckTender < ActiveRecord::Base

  validates_presence_of :user_id, :tender_id

  belongs_to :user
  belongs_to :tender
  
end
