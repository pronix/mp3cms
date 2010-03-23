class CartTrack < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user_id, :track_id
end

