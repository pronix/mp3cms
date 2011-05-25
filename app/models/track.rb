require 'aasm'
require 'open-uri'
require 'md5'
class Track < ActiveRecord::Base
  extend TrackSearch

  has_many :cart_tracks
  belongs_to :user
  belongs_to :satellite
  has_many :playlist_tracks, :dependent => :destroy
  has_many :playlists, :through => :playlist_tracks
  has_one :last_download, :dependent => :destroy

  before_validation :set_satellite, :on => :create
  validates :user_id, :data, :satellite_id, :presence => true

  attr_accessor :data_url
  attr_accessible :data, :data_url, :data_remote_url
  attr_accessible :title, :author, :bitrate, :user_id, :check_sum, :length

  if Rails.env == "production"
  has_attached_file :data,
                    :url => "/tracks/#{Satellite.master.id}/:fileseparator/:id/:basename.:extension",
                    :path => ":rails_root/data/tracks/#{Satellite.master.id}/:fileseparator/:id/:basename.:extension", #satellite_id - монтируем фс того сервера чей id
                    :extract_mp3tag => true
  else
  has_attached_file :data,
                    :url => "/tracks/:satellite_id/:id/:basename.:extension",
                    :path => ":rails_root/data/tracks/:satellite_id/:id/:basename.:extension", #satellite_id - монтируем фс того сервера чей id
                    :extract_mp3tag => true
  end

  validates_attachment_presence :data
  validates_attachment_size :data, :less_than => 20.megabytes
  validates_attachment_content_type :data,
       :content_type => ['application/mp3', 'application/x-mp3', 'audio/mpeg', 'audio/mp3'], :message => I18n.t("must_be_audio")

  validates_presence_of     :title, :author, :bitrate


  # проверяем что в сервисе не записан трек с таким же хешом
  validates_numericality_of :bitrate, :greater_than_or_equal_to => 128, :on => :create # проверяем битрайт

  validate :check_sum_uniq, :on => :create
  def check_sum_uniq
    errors.add(:base, "Такой трек уже загружен.") if Track.count(:conditions => { :check_sum => self.check_sum}) > 0
  end

  validate :ban_track?
  # проверяем что хеш по треку не занесен в таблицу блокировок
  def ban_track?
    errors.add(:base, "Трек заблокирован") if BanTrack.count(:conditions => { :check_sum => self.check_sum}) > 0
  end
  after_create :set_author_id

  # Удаляем лишнии сообщение о авторам трека если есть ошибки по самому треку
  #
  after_validation :clear_errors
  def clear_errors
    if errors.keys.any?{ |x| x.to_s.start_with?("data") }
      errors.delete(:user_id)
      errors.delete(:title)
      errors.delete(:author)
      errors.delete(:bitrate)
    end
  end

  # Scope
  scope :not_banned, where("tracks.state not in (:state)", :state => :banned)
  scope :latest,   lambda{ |*args| order("tracks.updated_at DESC").limit(args.first || Settings.limit_on_root_page) }
  scope :top_main, lambda{ order("tracks.count_downloads DESC").limit(Settings.limit_on_root_page) }
  scope :top_mp3,  lambda{ |*args| active.order("tracks.count_downloads DESC").limit(args.first || 20) }

  define_index do
    # indexes "LOWER(first_name)", :as => :first_name, :sortable => true
    indexes title, :sortable => true
    indexes author, :sortable => true
    indexes bitrate
    indexes user_id
    indexes user.login, :as => :login
    indexes user.email, :as => :email
    indexes state
    has count_downloads
    has data_file_size
    has author_id, :type => :string
    # group_by author
    set_property :delta => true, :threshold => Settings.delta_index
  end

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
    def group_by_author(params)
      unscoped.
        select("author, count(*) as track_count").
        where("LOWER(author) like :author and state = 'active'", :author => "#{q_downcase(params[:char])}%").
        group("author").
        order("author").
        paginate(:page => params[:page], :per_page => params[:per_page])
    end

    def to_author_id(author_name)
      Digest::MD5.hexdigest(author_name.mb_chars.downcase.to_s)[0..4]
    end

    # Загрузка файла по удаленной ссылке
    #
    def remote_upload(options)
      @user, @playlist, @track_url = options[:user], options[:playlist], options[:track_url]

      @track = new(:user_id   => @user.id, :playlists => [@playlist].compact, :data => open(@track_url))
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

  private

  def set_satellite
    self.satellite ||= Satellite.master
  end

end
