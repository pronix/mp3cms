class NewsItem < ActiveRecord::Base

 	acts_as_commentable

  has_attached_file :avatar,
  :styles => { :original => "150x150>" },
  :url => "/news/brief/:id/:style/:basename.:extension",
  :path => ":rails_root/public/news/brief/:id/:style/:basename.:extension"


  attr_accessible :header, :text, :meta, :description, :avatar, :state

  validates_presence_of :header, :text, :description, :state

  # has_many :comments #, :as => :commentable
  has_many :newsimages, :dependent => :destroy
  belongs_to :user

  define_index do
    indexes header, :sortable => true
    indexes text
    indexes state
    has created_at
    set_property :delta => true, :threshold => Settings.delta_index
  end

  # Популярные новости
  scope :top, where("news_items.comments_count > 0 and news_items.state = 'active'").order("news_items.comments_count DESC")

  # свежие новости новости
  scope :fresh, lambda{ where(:created_at => (Time.now-3.days)..Time.now, :state => "active" ).order("news_items.updated_at DESC") }
  scope :active, where(:state => 'active')
  scope :moderation, where(:state => "moderation")

  class << self

    def search_q(q,per_page)
      @r = search(Riddle.escape(q[:q]), :conditions => {:state => "active"}, :page => q[:page], :per_page => per_page, :star => true)
      @r.inpect && @r
    rescue
      [ ]
    end

    def search_newsitem(query, per_page, user = nil)
      return [] if query[:q].blank?
      @options = { :page => query[:page], :per_page => per_page }
      case query[:attribute]
      when "id"
        where(:id => query[:q].split(/\ |,|\./).select(&:present?), :state => "active").paginate(@options)
      else
        search_q(query,per_page)
      end
    end

  end # end class << self


end

