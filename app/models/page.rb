class Page < ActiveRecord::Base
  validates_presence_of :name, :permalink, :content
  has_friendly_id :permalink
  acts_as_textiled :content, :description => :lite_mode

end
