require 'aasm'
require 'open-uri'
require 'md5'
class Track < ActiveRecord::Base

  has_many :cart_tracks
  belongs_to :user
  belongs_to :satellite
  has_many :playlist_tracks, :dependent => :destroy
  has_many :playlists, :through => :playlist_tracks
  has_one :last_download, :dependent => :destroy

  before_validation_on_create :set_satellite
  validates_presence_of :user_id, :data, :satellite_id

  attr_accessor :data_url
  attr_accessible :data, :data_url, :data_remote_url
  attr_accessible :title, :author, :bitrate, :user_id, :check_sum, :length

  if RAILS_ENV == "production"
  has_attached_file :data,
                    :url => "/tracks/#{Satellite.f_master.id}/:fileseparator/:id/:basename.:extension",
                    :path => ":rails_root/data/tracks/#{Satellite.f_master.id}/:fileseparator/:id/:basename.:extension", #satellite_id - монтируем фс того сервера чей id
                    :extract_mp3tag => true
  else
  has_attached_file :data,
                    :url => "/tracks/:satellite_id/:id/:basename.:extension",
                    :path => ":rails_root/data/tracks/:satellite_id/:id/:basename.:extension", #satellite_id - монтируем фс того сервера чей id
                    :extract_mp3tag => true
  end

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
  after_create :set_author_id

  # Named scope
  named_scope :not_banned, :conditions => ["tracks.state not in (?)", :banned]
  # end Named scope
  named_scope :latest, lambda{ |*args| { :order => "tracks.created_at DESC", :limit => args.first || 10 }}

  define_index do
    # indexes "LOWER(first_name)", :as => :first_name, :sortable => true
    indexes title, :sortable => true
    indexes author, :sortable => true
    indexes bitrate
    indexes user_id
    indexes id
    indexes state
    has count_downloads
    has data_file_size
    has author_id, :type => :string
    # group_by author
    set_property :delta => true, :threshold => Settings[:delta_index]
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

    def to_author_id(author_name)
      Digest::MD5.hexdigest(author_name.mb_chars.downcase.to_s)[0..4]
    end

    def top_mp3(num = 20)
      active.all(:limit => num, :order => "tracks.rating DESC")
    end

    # ищем по автору и титлу - at
    # передаем хеш query = q
    def search_at(q)
      Lastsearch.create_at(q[:q]) if q[:remember] != "no"
      search("@(author,title) #{q[:q].to_s.mb_chars.downcase}",
             :match_mode => :extended, :conditions => { :state => "active" })
    end

    def search_a(q)
      Lastsearch.create_at(q[:q].to_s.mb_chars.downcase,'a') if q[:remember] != "no"
      search(:conditions => { :author => q[:q]}, :conditions => { :state => "active" })
    end

    def search_t(q)
      Lastsearch.create_at(q[:q].to_s.mb_chars.downcase,'t') if q[:remember] != "no"
      search(:conditions => { :title => q[:q] }, :conditions => { :state => "active" })
    end

    def user_search_track(query, per_page=10)
      unless query.has_key?("char")
        unless query[:q].blank?

          # почемуто не работает :star => true  - судя по логам даже запрос не идет
          query[:q] = '*' + query[:q] + '*'
          if query[:everywhere] == "yes"
            search_at(query)
          else
            if query[:title] == "yes" && query[:author] == "yes"
              search_at(query)
            else
              search_t(query) if query[:title] == "yes"
              search_a(query) if query[:author] == "yes"
            end
          end
        else
          []
        end
      else
        query[:q] = query[:char] + '*'
        search "^#{query[:char]}*"
      end
    end

    def search_track(query, per_page)
      query_options = { :per_page => per_page, :page => query[:page] }
      if query[:q].blank?
        # без строки поиска
        search(query_options.merge({ :conditions => { :state => "moderation"} }))
      else
        if query[:state] == "all" # поиск по трекам со всеми статусами
          case query[:attribute]
          when "more"
            search(query_options.merge({ :with => { "data_file_size" => query[:q].to_i..25000000 } }))
          when "less"
            search(query_options.merge({ :with => { "data_file_size" => 0..query[:q].to_i } }))
          when "well"
            search(query_options.merge({ :with => { "data_file_size" => query[:q].to_i..query[:q].to_i } }))
          when "login"
            if user = User.find_by_login(query[:q])
              search(query_options.merge({ :conditions => { :user_id => user.id } }))
            else
              []
            end
          else
            search(query_options.merge({ :conditions => { "#{query[:attribute]}" => query[:q] } }))
          end

        else
          unless query[:q].blank?
            case query[:attribute]
            when "more"
              search(query_options.merge({ :with => { "data_file_size" => query[:q].to_i..25000000 },
                                           :conditions => { :state => query[:state] } }))
            when "less"
              search(query_options.merge({ :with => { "data_file_size" => 0..query[:q] },
                                           :conditions => { :state => query[:state] } }))
            when "well"
              search(query_options.merge({ :with => { "data_file_size" => query[:q].to_i..query[:q].to_i },
                                           :conditions => { :state => query[:state] } }))
            when "everywhere"
              search(query[:q], query_options)
            when "author"
              search(query_options.merge({ :conditions => { :author => query[:q] } }))
            when "title"
              search(query_options.merge({ :conditions => { :title => query[:q] } }))
            else
              search(query_options.merge({ :conditions => {
                                             "#{query[:attribute]}" => query[:q],
                                             :state => query[:state] } }))
            end
          else
            search(query_options.merge({ :conditions => { :state => "moderation"} }))
          end
        end
      end

    end

    # Загрузка файла по удаленной ссылке
    #
    def remote_upload(options)
      @user, @playlist, @track_url = options[:user], options[:playlist], options[:track_url]

      @track = new(:user_id   => @user.id, :playlists => [@playlist].compact, :data => open(@track_url))
      unless @track.valid?
        @options = options
        if !@track.errors.on(:check_sum).blank? && (@double_track = find_by_check_sum(@track.check_sum))
          @options[:double_track] = @double_track
        end
        Notifier.deliver_remote_upload(options[:email], @user, @track, @options)
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
    self.satellite_id = Satellite.f_master.id unless self.satellite_id
  end



end
