require 'aasm'
require 'open-uri'

class Track < ActiveRecord::Base

  has_many :cart_tracks
  belongs_to :user
  has_many :playlist_tracks, :dependent => :destroy
  has_many :playlists, :through => :playlist_tracks

  validates_presence_of :user_id, :data
  #validates_uniqueness_of :check_sum, :message => "Такой трек уже загружен в систему"
  #before_validation :build_check_sum

  attr_accessor :data_url
  attr_accessible :data, :data_url, :data_remote_url
  attr_accessible :title, :author, :bitrate, :user_id, :check_sum
  has_attached_file :data,
                    :url => "/tracks/:id/:basename.:extension",
                    :path => ":rails_root/data/tracks/:id/:basename.:extension"

  before_validation :download_remote_data, :if => :data_url_provided?
  validates_presence_of :data_remote_url, :if => :data_url_provided?, :message => 'Файл недоступен'

  validates_attachment_presence :data
  validates_attachment_size :data, :less_than => 20.megabytes
  validates_attachment_content_type :data, :content_type => ['application/mp3', 'application/x-mp3', 'audio/mpeg', 'audio/mp3']

  #def get_check_sum
  #  if RAILS_ENV == "test" || RAILS_ENV == "cucumber"
  #    self.check_sum = self.title.to_s
  #  else
  #    self.check_sum = File.open(self.data.path).read.to_s.to_md5
  #  end
  #  self.save
  #end

  #def destroy_if_not_valid
  #  if self.not_uniq?
  #    self.destroy
  #  end
  #end

  #def has_ban_track?
  #  ban_track = BanTrack.find_by_check_sum(self.check_sum)
  #  ban_track.nil?
  #  false
  #end

  #def not_uniq?
  #  track = Track.find_by_check_sum(self.check_sum)
  #  track.nil?
  #  false
  #end

  def build_mp3_tags
    data_mp3 = self.data.path
    Mp3Info.open(data_mp3) do |mp3|
      begin
        unless mp3.tag.title.blank? && mp3.tag.artist.blank? && mp3.bitrate < 128
          mp3.tag.title = self.title.blank? ? mp3.tag.title.to_utf8 : self.title
          mp3.tag.artist = self.author.blank? ? mp3.tag.artist.to_utf8 : self.author
          self.title = mp3.tag.title if self.title.blank?
          self.author = mp3.tag.artist if self.author.blank?
          self.bitrate = mp3.bitrate
          self.save
        else
          self.destroy
        end
      rescue
        self.destroy
      end
    end
  end

  define_index do
    indexes title, :sortable => true
    indexes author
    indexes bitrate
    indexes user_id
    indexes id
    indexes state
    has data_file_size
    set_property :delta => true, :threshold => Settings[:delta_index]
  end

  def build_link(user, ip)
    return nil unless user
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

  def self.user_search_track(query, per_page)
    unless query.has_key?("char")
      unless query[:q].empty?
        if query[:everywhere] == "yes"
          if query[:remember] != "no"
            Lastsearch.create!(:url_string => query[:q], :url_attributes => "author title", :url_model => "track")
          end
          self.search "@(author,title) #{query[:q]}", :match_mode => :extended, :conditions => { :state => "active" }
        else
          if query[:title] == "yes" && query[:author] == "yes"
            if query[:remember] != "no"
              Lastsearch.create(:url_string => query[:q], :url_attributes => "author title", :url_model => "track")
            end
            self.search "@(author,title) #{query[:q]}", :match_mode => :extended, :conditions => { :state => "active" }
          else
            if query[:title] == "yes"
              if query[:remember] != "no"
                Lastsearch.create(:url_string => query[:q], :url_attributes => "title", :url_model => "track")
              end
              return self.search :conditions => { :title => query[:q] }, :conditions => { :state => "active" }
            end

            if query[:author] == "yes"
              if query[:remember] != "no"
                Lastsearch.create(:url_string => query[:q], :url_attributes => "author", :url_model => "track")
              end
              return self.search :conditions => { :author => query[:q]}, :conditions => { :state => "active" }
            end
          end
        end
      else
        []
      end
    else
      Track.paginate(:all, :conditions => ["title LIKE ?", "#{query[:char]}%"], :page => query[:page])
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

protected

  def build_check_sum
    if RAILS_ENV == "test" || RAILS_ENV == "cucumber"
      check_sum = title.to_s
    else
      check_sum = File.open(data.to_file.path).read.to_s.to_md5
    end
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

