class NewsItem < ActiveRecord::Base

  has_attached_file :avatar, :styles => { :original => "108x108>" }, :url => "/news_items/:id/:style/:filename"

  attr_accessible :header, :text, :meta, :news_category_ids, :description, :avatar

  validates_presence_of :header, :text, :news_category_ids, :description

  has_many :pictures, :as => :imageable
  has_many :newsships, :dependent => :destroy
  has_many :news_categories, :through => :newsships
  has_many :comments
  acts_as_commentable

  define_index do
    indexes header, :sortable => true
    indexes text
    indexes id
    set_property :delta => true, :threshold => Settings[:delta_index]
  end

  default_scope :order => "created_at DESC"
  named_scope :top # популяные новости

  # свежие новости новости
  named_scope :fresh, lambda{{  :conditions => { :created_at => (Time.now-3.days).to_s(:db)..(Time.now).to_s(:db) }}}


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

