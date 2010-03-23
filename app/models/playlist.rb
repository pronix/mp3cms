class Playlist < ActiveRecord::Base
  validates_presence_of :title, :user_id
  belongs_to :user
  has_many :comments
  has_and_belongs_to_many :tracks
  acts_as_commentable

  define_index do
    indexes title, :sortable => true
    indexes description
    indexes id
    indexes user_id
    set_property :delta => true, :threshold => Settings[:delta_index]
  end

  def self.search_playlist(query, per_page)
    if query[:attribute] != "login"
      unless query[:search_playlist].empty?
        if query[:attribute] = "playlist"
          self.search query[:search_playlist], :per_page => per_page, :page => query[:page]
        else
          self.search :conditions => { "#{query[:attribute]}" => query[:search_playlist] }, :per_page => per_page, :page => query[:page]
        end
      else
        []
      end
    else
      user = User.search :conditions => { :login => query[:search_playlist] }
      unless user.empty?
        self.search :conditions => { :user_id => user.first.id}, :per_page => per_page, :page => query[:page]
      else
        []
      end
    end
  end

  def owner
    self.user.login
  end

  def add_tracks(params)
    params.to_a.each do |track_id|
      track = Track.find track_id
      self.tracks << track unless self.tracks.include?(track)
    end
  end

end

