class News < ActiveRecord::Base
  belongs_to :news_category

  validates_presence_of :news_category_id
end

