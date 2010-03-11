class Picture < ActiveRecord::Base
  belongs_to :imageable, :plymorphic => true
end

