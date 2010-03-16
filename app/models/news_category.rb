class NewsCategory < ActiveRecord::Base
  attr_accessible :name

  validates_presence_of :name

  has_many :newsships, :dependent => :destroy
  has_many :news_items, :through => :newsships
end

