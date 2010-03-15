class NewsCategory < ActiveRecord::Base
  has_many :newsships
  has_many :news_items, :through => :newsships
end

