class PlaylistTrack < ActiveRecord::Base
  acts_as_nested_set
  belongs_to :playlist
  belongs_to :track
end

