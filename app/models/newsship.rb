class Newsship < ActiveRecord::Base
  attr_accessible :news_item_id, :news_category_id
  belongs_to :news_item, :dependent => :destroy
  belongs_to :news_category
end

