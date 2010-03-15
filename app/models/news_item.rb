class NewsItem < ActiveRecord::Base

  validates_presence_of :header, :text

  has_many :pictures, :as => :imageable
  has_many :newsships
  has_many :news_categories, :through => :newsships, :source => :news_item

  define_index do
    indexes header, :sortable => true
    indexes text
    indexes id
    set_property :delta => true, :threshold => Settings[:delta_index]
  end

end

