class NewsItem < ActiveRecord::Base

  attr_accessible :header, :text, :meta, :news_category_ids

  validates_presence_of :header, :text, :news_category_ids

  has_many :pictures, :as => :imageable
  has_many :newsships, :dependent => :destroy
  has_many :news_categories, :through => :newsships

  define_index do
    indexes header, :sortable => true
    indexes text
    indexes id
    set_property :delta => true, :threshold => Settings[:delta_index]
  end

end

