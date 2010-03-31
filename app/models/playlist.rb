class Playlist < ActiveRecord::Base
  validates_presence_of :title, :user_id
  belongs_to :user
  has_many :comments
  has_many :playlist_tracks, :dependent => :destroy
  has_many :tracks, :through => :playlist_tracks

  named_scope :next, lambda { |p| {:conditions => ["id > ?", p.id], :limit => 1, :order => "id DESC"} }
  named_scope :prev, lambda { |p| {:conditions => ["id < ?", p.id], :limit => 1, :order => "id DESC"} }

  def tracks_tree
    track_ids = []
    self.playlist_tracks.roots.each do |root|
      track_ids << root.track_id if Track.find(root.track_id)
    end
    Track.find(track_ids)
  end

  has_attached_file :icon,
                    :url  => "/playlists/icons/:id/:style_:basename.:extension",
                    :path => ":rails_root/public/playlists/icons/:id/:style_:basename.:extension",
                    :default_url => "/images/playlists/default_:style.gif",
    	              :styles => { :thumb => '120x120' }

  validates_attachment_size :icon, :less_than => 2.megabytes
  validates_attachment_content_type :icon, :content_type => ['image/gif', 'image/png', 'image/jpeg']

  define_index do
    indexes title, :sortable => true
    indexes description
    indexes id
    indexes user_id
    set_property :delta => true, :threshold => Settings[:delta_index]
  end

  def self.search_playlist(query, per_page)
    if query[:attribute] != "login"
      unless query[:q].blank?
        if query[:attribute] = "playlist"
          self.search query[:q], :per_page => per_page, :page => query[:page]
        else
          self.search :conditions => { "#{query[:attribute]}" => query[:q] }, :per_page => per_page, :page => query[:page]
        end
      else
        []
      end
    else
      user = User.search :conditions => { :login => query[:q] }
      unless user.blank?
        self.search :conditions => { :user_id => user.first.id}, :per_page => per_page, :page => query[:page]
      else
        []
      end
    end
  end

  def owner
    self.user.login
  end

  def description_on_not
    self.description.blank? ? "Описание не заполнено" : self.description
  end

  def add_tracks(params)
    params.to_a.each do |track_id|
      track = Track.find track_id
      self.tracks << track unless self.tracks.include?(track)
    end
  end

end

