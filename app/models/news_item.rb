class NewsItem < ActiveRecord::Base

  attr_accessible :header, :text, :meta, :news_category_ids

  validates_presence_of :header, :text, :news_category_ids

  has_many :pictures, :as => :imageable
  has_many :newsships, :dependent => :destroy
  has_many :news_categories, :through => :newsships
  has_many :comments
  acts_as_commentable

  has_attached_file :avatar, :styles => { :origin => "108x108>" }

  define_index do
    indexes header, :sortable => true
    indexes text
    indexes id
    set_property :delta => true, :threshold => Settings[:delta_index]
  end

  def self.search_newsitem(query, per_page)
    unless query[:search_string].empty?
      case query[:attribute]
        when "id"
          NewsItem.search :conditions => { :id => query[:search_string] }, :page => query[:page], :per_page => per_page
      else
        NewsItem.search query[:search_string], :page => query[:page], :per_page => per_page
      end
    else
      []
    end
  end

end

