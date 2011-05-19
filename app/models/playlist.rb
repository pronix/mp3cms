class Playlist < ActiveRecord::Base
 	acts_as_commentable

  belongs_to :user

  has_many :playlist_tracks, :dependent => :destroy
  has_many :tracks, :through => :playlist_tracks

  scope :next, lambda { |p|
    where("id > :playlist_id and user_id = :user_id", :playlist_id => p.id, :user_id => p.user_id).order("id")
  }

  scope :prev, lambda { |p|
    where("id < :playlist_id and user_id = :user_id",  :playlist_id => p.id, :user_id => p.user_id).order("id DESC")
  }

  scope :next_allow_not_my, lambda { |p| where("id > :playlist_id", :playlist_id => p.id).order("id")  }
  scope :prev_allow_not_my, lambda { |p|  where("id < :playlist_id", :playlist_id => p.id).order("id DESC")  }

  scope :latest, lambda{ |*args| order("playlists.created_at DESC").limit(args.first || 9) }

  def tracks_tree
    Track.where(:id => self.playlist_tracks.roots.map(&:track_id))
  end

  has_attached_file :icon, :whiny => false,
                    :url  => "/playlists/icons/:id/:style_:basename.:extension",
                    :path => ":rails_root/public/playlists/icons/:id/:style_:basename.:extension",
                    :default_url => "/images/playlists/default_:style.png",
    	              :styles => { :thumb => ['120x120#', :png] },
                    :convert_options => { :thumb => '-background none -layers merge +repage -gravity center -extent 120x120 ' }

  validates_attachment_size :icon, :less_than => 2.megabytes, :message => I18n.t("should_be_less_2Mb")
  validates_attachment_content_type :icon, :content_type =>  /image/, :message => I18n.t("must_be_image")
  validates_presence_of :title, :user_id
  validates_length_of :title, :maximum=> 50


  # Sphinx Index
  #
  define_index do
    indexes title, :sortable => true
    indexes description
    indexes id
    indexes user_id
    set_property :delta => true, :threshold => Settings.delta_index
  end

  # Владелец плейлиста
  #
  def owner
    self.user.try(:login)
  end

  # Описание плейлиста
  #
  def description_on_not
    self.description.blank? ? "Описание не заполнено" : self.description
  end

  # Добавление трека в плейлист
  # @params - список ид треков
  #
  def add_tracks(params)
    [ params ].flatten.compact.each do |track_id|
      if (@track = Track.find_by_id(track_id)) && !self.tracks.include?(@track)
        self.tracks << @track
      end
    end
  end

  class << self

    # Поиск плейлистов
    #
    def search_playlist(query, per_page = 10)
      result = []
      @q = Riddle.escape("*#{query[:q].to_s.mb_chars.downcase}*" ) unless query[:q].blank?

      if query[:attribute] != "login"
        unless @q.blank?
          if query[:attribute] = "playlist"
            result = self.search(@q, search_default_options(query))
          else
            result = self.search( search_default_options(query).merge({ :conditions => { "#{query[:attribute]}" => @q } }) )
          end
        end
      else
        if (@user = User.find_by_login(query[:q].to_s.mb_chars))
          result = self.search(search_default_options(query).merge({ :conditions => { :user_id => @user.id}}))
        end
      end

      result
    end

    private

    # Параметры поиска по умолчанию
    #
    def search_default_options(query)
      { :per_page => per_page, :page => query[:page], :star => true}
    end

  end # end class << self

end

