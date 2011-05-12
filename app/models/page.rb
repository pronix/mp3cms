class Page < ActiveRecord::Base
  validates_presence_of :name, :permalink, :content
  has_friendly_id :permalink
end
