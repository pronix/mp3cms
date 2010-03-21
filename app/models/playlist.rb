class Playlist < ActiveRecord::Base
  validates_presence_of :title
  belongs_to :user
  has_many :comments
  has_many :tracks
  acts_as_commentable

  define_index do
    indexes title, :sortable => true
    indexes description
    indexes id
    indexes user_id
    set_property :delta => true, :threshold => Settings[:delta_index]
  end

  def self.search_playlist(query, page, per_page)
    if query[:attribute] != "login"
      self.search :conditions => { "#{query[:attribute]}" => query[:search_playlist] }, :per_page => per_page, :page => page
    else
      user = User.search :conditions => { :login => query[:search_playlist] }
      unless user.empty?
        self.search :conditions => { :user_id => user.first.id}, :per_page => per_page, :page => page
      else
        []
      end
    end
  end

  def owner
    self.user.login
  end

end

