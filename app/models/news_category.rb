class NewsCategory < ActiveRecord::Base
  attr_accessible :name
  has_many :newsships
  has_many :news_items, :through => :newsships
end

