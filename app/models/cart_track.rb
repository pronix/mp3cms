class CartTrack < ActiveRecord::Base
  belongs_to :user
  belongs_to :track
  validates_presence_of :user_id, :track_id
end

