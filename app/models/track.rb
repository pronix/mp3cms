require 'aasm'
require 'open-uri'

class Track < ActiveRecord::Base

  validates_presence_of :playlist_id, :user_id, :data
  belongs_to :playlist
  belongs_to :user

  attr_accessor :data_url
  attr_accessible :data, :data_url, :data_remote_url
  attr_accessible :title, :author, :bitrate, :user_id, :playlist_id
  has_attached_file :data,
                    :url  => "/tracks/:id/:basename.:extension",
                    :path => ":rails_root/data/tracks/:id/:basename.:extension"

  before_validation :download_remote_data, :if => :data_url_provided?
  validates_presence_of :data_remote_url, :if => :data_url_provided?, :message => 'Файл недоступен'

  validates_attachment_presence :data
  validates_attachment_size :data, :less_than => 20.megabytes
  validates_attachment_content_type :data, :content_type => ['audio/mp3', 'audio/mpeg']

  define_index do
    indexes title, :sortable => true
    indexes author
    indexes data_file_size
    indexes bitrate
    indexes user_id
    indexes id
    indexes state
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

  def self.search_track(query)
    if query != "default"
        if query[:state] == "all"
          if query[:attribute] == "more" or query[:attribute] == "less" or query[:attribute] == "well"
            case query[:attribute]
              when "more"
                self.search :with => { "data_file_size" => query[:search_track].to_i..25000000  }
              when "less"
                self.search :with => { "data_file_size" => 0..query[:search_track]  }
              when "well"
                self.search :conditions => { "data_file_size" => query[:search_track].to_i  }
            end
          else
            if query[:attribute] == "login"
              user = User.find_by_login(query[:search_track])
              if user
                self.search :conditions => { :user_id => user.id  }
              end
            else
              self.search :conditions => { "#{query[:attribute]}" => query[:search_track]  }
            end
          end
        else
          if query[:attribute] == "more" or query[:attribute] == "less" or query[:attribute] == "well"
            case query[:attribute]
              when "more"
                self.search :with => { "data_file_size" => query[:search_track].to_i..25000000  }, :conditions => { :state => query[:state] }
              when "less"
                self.search :with => { "data_file_size" => 0..query[:search_track]  }, :conditions => { :state => query[:state] }
              when "well"
                self.search :conditions => { "data_file_size" => query[:search_track].to_i, :state => query[:state]  }
            end
          else
            self.search :conditions => { "#{query[:attribute]}" => query[:search_track], :state => query[:state]  }
          end
        end
    else
        self.search :conditions => { :state => "moderation"}
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

