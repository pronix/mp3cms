require 'aasm'
require 'open-uri'

class Track < ActiveRecord::Base

  has_many :cart_tracks
  belongs_to :user
  has_many :playlist_tracks, :dependent => :destroy
  has_many :playlists, :through => :playlist_tracks
  has_one :last_download, :dependent => :destroy

  validates_presence_of :user_id, :data

  attr_accessor :data_url
  attr_accessible :data, :data_url, :data_remote_url
  attr_accessible :title, :author, :bitrate, :user_id, :check_sum
  has_attached_file :data,
                    :url => "/tracks/:id/:basename.:extension",
                    :path => ":rails_root/data/tracks/:id/:basename.:extension",
                    :extract_mp3tag => true



  before_validation :download_remote_data, :if => :data_url_provided?
  validates_presence_of :data_remote_url, :if => :data_url_provided?, :message => 'Файл недоступен'

  validates_attachment_presence :data
  validates_attachment_size :data, :less_than => 20.megabytes
  validates_attachment_content_type :data, :content_type => ['application/mp3', 'application/x-mp3', 'audio/mpeg', 'audio/mp3']

  validates_presence_of     :title, :author, :bitrate

  validates_uniqueness_of   :check_sum, :on => :create, :message => "Трек уже загружен"
  # проверяем что в сервисе не записан трек с таким же хешом
  validates_numericality_of :bitrate, :greater_than_or_equal_to => 128, :on => :create # проверяем битрайт

  validate :ban_track?
  # проверяем что хеш по треку не занесен в таблицу блокировок
  def ban_track?
    errors.add_to_base("Трек заблокирован") if BanTrack.count(:conditions => { :check_sum => self.check_sum}) > 0
  end

  define_index do
    indexes title, :sortable => true
    indexes author
    indexes bitrate
    indexes user_id
    indexes id
    indexes state
    has count_downloads
    has data_file_size
    set_property :delta => true, :threshold => Settings[:delta_index]
  end

  def build_link(user, ip)
    return nil unless user
    ActiveRecord::Base.transaction do
    # списание с баланса пользователя за скачивание трека
    user.debit_download_track("Трек № #{self.id} скачан")
    file_link = user.file_links.build :track_id => self.id,
                          :file_name => self.data_file_name,
                          :file_path => self.data.path,
                          :file_size => self.data_file_size,
                          :content_type => self.data_content_type,
                          :link => "".secret_link(ip),
                          :ip => ip,
                          :expire => 1.week.from_now
    file_link
    end
  end

  def self.top_mp3(num = 20)
    self.find(:all, :order => "rating DESC", :limit => num)
  end

  def recount_top_download
    self.count_downloads += 1
    self.save
  end

  def delete_cart_tracks
    self.cart_tracks.destroy_all
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


      # ищем по автору и титлу - at
      # передаем хеш query = q
  def self.search_at(q)
      Lastsearch.create_at(q[:q]) if q[:remember] != "no"
      self.search "@(author,title) #{q[:q]}", :match_mode => :extended, :conditions => { :state => "active" }
  end

  def self.search_a(q)
      Lastsearch.create_at(q[:q],'a') if q[:remember] != "no"
      return self.search :conditions => { :author => q[:q]}, :conditions => { :state => "active" }
  end

  def self.search_t(q)
      Lastsearch.create(q[:q],'t') if q[:remember] != "no"
      return self.search :conditions => { :title => q[:q] }, :conditions => { :state => "active" }
  end


  def self.user_search_track(query, per_page)
    unless query.has_key?("char")
      unless query[:q].blank?
        
        # почемуто не работает :star => true  - судя по логам даже запрос не идет
        query[:q] = '*' + query[:q] + '*'
        if query[:everywhere] == "yes"
            self.search_at(query)
        else
          if query[:title] == "yes" && query[:author] == "yes"
              self.search_at(query)
          else
            self.search_t(query) if query[:title] == "yes"
            self.search_a(query) if query[:author] == "yes"
          end
        end
      else
        []
      end
    else
        query[:q] = '*' + query[:char] + '*'
        self.search_at(query)
    end
  end

  def self.search_track(query, per_page)

    if query[:q].blank?
      # без строки поиска
      self.search :conditions => { :state => "moderation"}, :per_page => per_page, :page => query[:page]
    else
      if query[:state] == "all" # поиск по трекам со всеми статусами
        case query[:attribute]
        when "more"
          self.search :with => { "data_file_size" => query[:q].to_i..25000000 },
          :per_page => per_page, :page => query[:page]
        when "less"
          self.search :with => { "data_file_size" => 0..query[:q].to_i },
          :per_page => per_page, :page => query[:page]
        when "well"
          self.search :with => { "data_file_size" => query[:q].to_i..query[:q].to_i },
          :per_page => per_page, :page => query[:page]
        when "login"
          if user = User.find_by_login(query[:q])
            self.search :conditions => { :user_id => user.id }, :per_page => per_page, :page => query[:page]
          else
            []
          end
        else
          self.search :conditions => { "#{query[:attribute]}" => query[:q] },
          :per_page => per_page, :page => query[:page]
        end

      else
        unless query[:q].blank?
          case query[:attribute]
          when "more"
            self.search :with => { "data_file_size" => query[:q].to_i..25000000 },
            :conditions => { :state => query[:state] }, :per_page => per_page, :page => query[:page]
          when "less"
            self.search :with => { "data_file_size" => 0..query[:q] },
            :conditions => { :state => query[:state] }, :per_page => per_page, :page => page
          when "well"
            self.search :with => { "data_file_size" => query[:q].to_i..query[:q].to_i },
            :conventions => { :state => query[:state] }, :per_page => per_page, :page => query[:page]
          when "everywhere"
            self.search query[:q], :per_page => per_page, :page => query[:page]
          when "author"
            self.search :conditions => { :author => query[:q] }, :per_page => per_page, :page => query[:page]
          when "title"
            self.search :conditions => { :title => query[:q] }, :per_page => per_page, :page => query[:page]
          else
            self.search :conditions => { "#{query[:attribute]}" => query[:q],
              :state => query[:state] }, :per_page => per_page, :page => query[:page]
          end
        else
          self.search :conditions => { :state => "moderation"}, :per_page => per_page, :page => query[:page]
        end
      end
    end

  end

  def owner
    self.user.login
  end

  def fullname
    "#{self.author} - #{self.title}"
  end

  def has_state?(some_state)
    self.state == some_state
  end

private

  def data_url_provided?
    !self.data_url.blank?
  end

  def download_remote_data
    self.data = do_download_remote_data
    self.data_remote_url = data_url
  end

  def do_download_remote_data
    io = open(URI.parse(data_url))
    def io.original_filename; base_uri.path.split('/').last; end
    io.original_filename.blank? ? nil : io
    rescue #OpenURI::HTTPError# catch url errors with validations instead of exceptions (Errno::ENOENT, OpenURI::HTTPError, etc...)
      #rescue_from Errno::ENOENT, :with => :url_upload_not_found
      #rescue_from Errno::ETIMEDOUT, :with => :url_upload_not_found
      #rescue_from OpenURI::HTTPError, :with => :url_upload_not_found
      #rescue_from Timeout::Error, :with => :url_upload_not_found
  end

end

# добавление в очередь задания для загрузки файлов по ссылке
class TrackJob < Struct.new :track_url, :playlist, :user
  def perform
    @track = Track.new :user_id => user.id, :data_url => track_url
    @track.playlists << playlist
    @track.save
    @track.build_mp3_tags
  end
end

