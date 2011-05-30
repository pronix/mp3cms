require 'aasm'
require 'open-uri'
require 'md5'
class Track < ActiveRecord::Base
  FILE_FORMATS = ["mp3", "doc", "rar", "txt"]
  concerned_with :search, :validation


  has_many :cart_tracks
  belongs_to :user
  belongs_to :satellite
  has_many :playlist_tracks, :dependent => :destroy
  has_many :playlists, :through => :playlist_tracks
  has_one :last_download, :dependent => :destroy



  attr_accessor :data_url
  attr_accessible :data, :data_url, :data_remote_url
  attr_accessible :title, :author, :bitrate, :user_id, :check_sum, :length

  after_create :set_author_id

  if Rails.env == "production"
  has_attached_file :data,
                    :url => "/tracks/#{Satellite.master.id}/:fileseparator/:id/:basename.:extension",
                    :path => ":rails_root/data/tracks/#{Satellite.master.id}/:fileseparator/:id/:basename.:extension",
                    #satellite_id - монтируем фс того сервера чей id
                    :extract_mp3tag => true
  else
  has_attached_file :data,
                    :url => "/tracks/:satellite_id/:id/:basename.:extension",
                    :path => ":rails_root/data/tracks/:satellite_id/:id/:basename.:extension",
                    #satellite_id - монтируем фс того сервера чей id
                    :extract_mp3tag => true
  end


  # Scope
  scope :not_banned, where("tracks.state not in (:state)", :state => :banned)
  scope :top_main, lambda{ active.order("tracks.count_downloads DESC").limit(Settings.limit_on_root_page) }
  scope :latest, lambda{ |*args| where(:state => "active").order("updated_at DESC").limit(args.first || 20) }


  include AASM
  aasm_column :state
  aasm_initial_state :moderation
  aasm_state :moderation
  aasm_state :banned
  aasm_state :active
  aasm_event :to_active do
    transitions :to => :active, :from => [:moderation, :banned]
  end
  aasm_event :to_banned do
    transitions :to => :banned, :from => [:active, :moderation]
  end
  aasm_event :to_moderation do
    transitions :to => :moderation, :from => [:active, :banned]
  end

  # Имя файла которое выдается при скачвание или архивирование треков
  #
  def track_name(ext = 'mp3')
    "#{self.author} - #{self.title}_(#{Settings.app_name}).#{ext}"
  end

  def set_author_id
    self.author_id = self.class.to_author_id(self.author)
    self.fileseparator = MD5.new(self.title).to_s[0..2]
    save!
  end

  def build_link(user, ip)
    # списание с баланса пользователя за скачивание трека
    if user.debit_download_track("Трек № #{self.id} скачан")
      file_link = user.file_links.build({ :track_id => self.id,
                                          :file_name => self.data_file_name,
                                          :file_path => self.data.path,
                                          :file_size => self.data_file_size,
                                          :content_type => self.data_content_type,
                                          :link => "".secret_link(ip),
                                          :ip => ip,
                                          :expire => 1.week.from_now })
      file_link
    end

  end

  # Продолжительность трека
  def duration
    Time.at(self.length.to_f).strftime("%M:%S")
  end

  def data_file_size_in_mega
    self.data_file_size / 1.megabyte
  rescue
    ''
  end


  def recount_top_download
    self.count_downloads += 1
    self.save
  end

  def delete_cart_tracks
    self.cart_tracks.destroy_all
  end

  class << self

    def to_player(_tracks, key_tracks)
      [ _tracks ].flatten.compact.map { |v|
        { :track => {
            :id =>    key_tracks.find{|k,track_id| track_id == v.id  }.first,
            :title => ERB::Util.html_escape(v.title),
            :author => ERB::Util.html_escape(v.author),
            :bitrate => v.bitrate,
            :data_file_size => v.data_file_size
          }
        }
      }.to_json
    end

    def group_by_author(params)
      unscoped.
        select("author, count(*) as track_count").
        where("LOWER(author) like :author and state = 'active'", :author => "#{q_downcase(params[:char])}%").
        group("author").
        order("author").
        paginate(:page => params[:page], :per_page => params[:per_page])
    end

    def to_author_id(author_name)
      Digest::MD5.hexdigest(author_name.to_s.mb_chars.downcase.to_s)[0..4]
    end

    # Загрузка файла по удаленной ссылке
    #
    def remote_upload(options)
      @user, @playlist, @track_url = options[:user], options[:playlist], options[:track_url]

      @track = new(:user_id   => @user.id, :playlists => [@playlist].compact, :data => ( open(@track_url) rescue nil ))
      unless @track.valid?
        @options = options
        if (@double_track = find_by_check_sum(@track.check_sum))
          @options[:double_track_id] = @double_track.id
        end
        Notification.remote_upload(options[:email], @user, @track, @options).deliver
      else
        @track.save!
      end

    end

  end # end class << self


  def owner
    self.user.try(:login)
  end

  def fullname
    "#{self.author} - #{self.title}"
  end

  def has_state?(some_state)
    self.state == some_state
  end


end
