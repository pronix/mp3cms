require 'aasm'
require 'open-uri'

class Track < ActiveRecord::Base

  validates_presence_of :user_id, :data
  has_and_belongs_to_many :playlists
  belongs_to :user

  attr_accessor :data_url
  attr_accessible :data, :data_url, :data_remote_url
  attr_accessible :title, :author, :bitrate, :user_id, :playlist_id
  has_attached_file :data,
                    :url => "/tracks/:id/:basename.:extension",
                    :path => ":rails_root/data/tracks/:id/:basename.:extension"

  before_validation :download_remote_data, :if => :data_url_provided?
  validates_presence_of :data_remote_url, :if => :data_url_provided?, :message => 'Файл недоступен'

  validates_attachment_presence :data
  validates_attachment_size :data, :less_than => 20.megabytes
  validates_attachment_content_type :data, :content_type => ['application/mp3', 'application/x-mp3', 'audio/mpeg', 'audio/mp3']

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

  def build_mp3_tags
    data_mp3 = self.data.path
    Mp3Info.open(data_mp3) do |mp3|
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
    end
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
    unless query[:search_string].empty?
      if query[:everywhere] == "yes"
        if query[:remember] != "no"
          Lastsearch.create!(:url_string => query[:search_string], :url_attributes => "author title", :url_model => "track")
        end
        self.search "@(author,title) #{query[:search_string]}", :match_mode => :extended
      else
        if query[:title] == "yes" && query[:author] == "yes"
          if query[:remember] != "no"
            Lastsearch.create(:url_string => query[:search_string], :url_attributes => "author title", :url_model => "track")
          end
          self.search "@(author,title) #{query[:search_string]}", :match_mode => :extended
        else
          if query[:title] == "yes"
            if query[:remember] != "no"
              Lastsearch.create(:url_string => query[:search_string], :url_attributes => "title", :url_model => "track")
            end
            return self.search :conditions => { :title => query[:search_string] }
          end

          if query[:author] == "yes"
            if query[:remember] != "no"
              Lastsearch.create(:url_string => query[:search_string], :url_attributes => "author", :url_model => "track")
            end
            return self.search :conditions => { :author => query[:search_string]}
          end
        end
      end
    else
      []
    end
  end

  def self.search_track(query, per_page)
    if query != "default"
        if query[:state] == "all"
          if query[:attribute] == "more" or query[:attribute] == "less" or query[:attribute] == "well"
            case query[:attribute]
              when "more"
                self.search :with => { "data_file_size" => query[:search_track].to_i..25000000 }, :per_page => per_page, :page => query[:page]
              when "less"
                self.search :with => { "data_file_size" => 0..query[:search_track].to_i }, :per_page => per_page, :page => query[:page]
              when "well"
                self.search :with => { "data_file_size" => query[:search_track].to_i..query[:search_track].to_i }, :per_page => per_page, :page => query[:page]
            end
          else
            if query[:attribute] == "login"
              user = User.find_by_login(query[:search_track])
              if user
                self.search :conditions => { :user_id => user.id }, :per_page => per_page, :page => query[:page]
              end
            else
              self.search :conditions => { "#{query[:attribute]}" => query[:search_track] }, :per_page => per_page, :page => query[:page]
            end
          end
        else
          unless query[:search_track].empty?
            case query[:attribute]
              when "more"
                self.search :with => { "data_file_size" => query[:search_track].to_i..25000000 }, :conditions => { :state => query[:state] }, :per_page => per_page, :page => query[:page]
              when "less"
                self.search :with => { "data_file_size" => 0..query[:search_track] }, :conditions => { :state => query[:state] }, :per_page => per_page, :page => page
              when "well"
                self.search :with => { "data_file_size" => query[:search_track].to_i..query[:search_track].to_i }, :conventions => { :state => query[:state] }, :per_page => per_page, :page => query[:page]
              when "everywhere"
                self.search query[:search_track], :per_page => per_page, :page => query[:page]
              when "author"
                self.search :conditions => { :author => query[:search_track] }, :per_page => per_page, :page => query[:page]
              when "title"
                self.search :conditions => { :title => query[:search_track] }, :per_page => per_page, :page => query[:page]
              else
              self.search :conditions => { "#{query[:attribute]}" => query[:search_track], :state => query[:state] }, :per_page => per_page, :page => query[:page]
            end
          else
            []
          end
        end
    else
        self.search :conditions => { :state => "moderation"}, :per_page => per_page, :page => query[:page]
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

