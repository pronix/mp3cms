class Newsimage < ActiveRecord::Base

  has_attached_file :photo,
  :styles => { :medium => "600x600>", :thumb => "100x100>" },
  :url => "/news/images/:id/:style/:basename.:extension",
  :path => ":rails_root/public/news/images/:id/:style/:basename.:extension"

  belongs_to :news_item

  validates_presence_of :news_item_id

end

