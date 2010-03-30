class BanTrack < ActiveRecord::Base
  validates_presence_of :check_sum
end

