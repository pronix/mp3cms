class NewsItem < ActiveRecord::Base

  has_attached_file :avatar,
  :styles => { :original => "150x150>" },
  :url => "/news/brief/:id/:style/:basename.:extension",
  :path => ":rails_root/public/news/brief/:id/:style/:basename.:extension"


  attr_accessible :header, :text, :meta, :description, :avatar, :state

  validates_presence_of :header, :text, :description, :state

  has_many :comments #, :as => :commentable
  has_many :newsimages, :dependent => :destroy
  belongs_to :user

  acts_as_commentable

  define_index do
    indexes header, :sortable => true
    indexes text
    indexes id
    indexes state
    has created_at
    set_property :delta => true, :threshold => Settings.delta_index
  end

  default_scope :order => "news_items.updated_at DESC"

  # Популярные новости
  scope :top, where("news_items.comments_count > 0 and news_items.state = 'active'").order("news_items.comments_count DESC")

  # свежие новости новости
  scope :fresh, lambda{ where(:created_at => (Time.now-3.days).to_s(:db)..(Time.now).to_s(:db), :state => "active" ) }
  scope :active, where(:state => 'active')
  scope :moderation, where(:state => "moderation")
  class << self
    def search_q(q,per_page)
      search q[:q], :conditions => {:state => "active"}, :page => q[:page], :per_page => per_page
    end

    def search_newsitem(query, per_page, user = nil)
      unless query[:q].blank?
        case query[:attribute]
        when "id"
          if user.blank?
            search :conditions => { :id => query[:q], :state => "active" }, :page => query[:page], :per_page => per_page
          else
            if user.admin?
              search :conditions => { :id => query[:q] }, :page => query[:page], :per_page => per_page
            else
              search :conditions => { :id => query[:q], :state => "active" }, :page => query[:page], :per_page => per_page
            end
          end
        when "meta"
          search_q(query,per_page)
        else
          search_q(query,per_page)
        end
      else
        []
      end
    end

  end # end class << self


end

