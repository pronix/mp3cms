class NewsItem < ActiveRecord::Base

  has_attached_file :avatar, :styles => { :original => "298x200>" }, :url => "/news_items/:id/:style/:filename"

  attr_accessible :header, :text, :meta, :description, :avatar

  validates_presence_of :header, :text, :description

  has_many :comments
  belongs_to :user

  acts_as_commentable

  define_index do
    indexes header, :sortable => true
    indexes text
    indexes id
    has created_at
    set_property :delta => true, :threshold => Settings[:delta_index]
  end

  default_scope :order => "news_items.created_at DESC"

  named_scope :top, :conditions => ["news_items.comments_count > 0"],
                    :order =>  "news_items.comments_count DESC" # популяные новости

  # свежие новости новости
  named_scope :fresh, lambda{{  :conditions => { :created_at => (Time.now-3.days).to_s(:db)..(Time.now).to_s(:db) }}}


  def self.search_newsitem(query, per_page)
    unless query[:search_string].empty?
      case query[:attribute]
        when "id"
          NewsItem.search :conditions => { :id => query[:search_string] }, :page => query[:page], :per_page => per_page
        when "meta"
          NewsItem.search query[:search_string], :page => query[:page], :per_page => per_page
      else
        NewsItem.search query[:search_string], :page => query[:page], :per_page => per_page
      end
    else
      []
    end
  end

end

