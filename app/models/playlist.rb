class Playlist < ActiveRecord::Base
  validates_presence_of :title, :user_id
  belongs_to :user
  has_many :comments
  has_many :playlist_tracks, :dependent => :destroy
  has_many :tracks, :through => :playlist_tracks

  named_scope :next, lambda { |p| {:conditions => ["id > ? and user_id = ?", p.id, p.user_id], :limit => 1, :order => "id DESC"} }
  named_scope :prev, lambda { |p| {:conditions => ["id < ? and user_id = ?", p.id, p.user_id], :limit => 1, :order => "id DESC"} }

  named_scope :next_allow_not_my, lambda { |p| {:conditions => ["id > ?", p.id], :limit => 1, :order => "id DESC"} }
  named_scope :prev_allow_not_my, lambda { |p| {:conditions => ["id < ?", p.id], :limit => 1, :order => "id DESC"} }

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


  def owner
    self.user.try(:login)
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


  class << self

    def search_playlist(query, per_page=10)
      result = []
      if query[:attribute] != "login"
        unless query[:q].blank?
          if query[:attribute] = "playlist"
            result = self.search(query[:q], search_default_options(query))
          else
            result = self.search( search_default_options(query).merge({ :conditions => { "#{query[:attribute]}" => query[:q] } }) )
          end
        end
      else
        if (@user = User.search(:conditions => { :login => query[:q] }).first)
          result = self.search(search_default_options(query).merge({ :conditions => { :user_id => @user.id}}))
        end
      end
      result
    end

    private
    def search_default_options(query)
      { :per_page => per_page, :page => query[:page] }
    end


  end # end class << self




end

