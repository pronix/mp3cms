require 'aasm'

class Track < ActiveRecord::Base

  validates_presence_of :playlist_id, :user_id, :data
  belongs_to :playlist

  data_path = RAILS_ENV["production"] ? ":rails_root/data/tracks/:id/:basename.:extension" : ":rails_root/data/tracks/test/:id/:basename.:extension"

  has_attached_file :data,
                    :url  => "/tracks/:id/:basename.:extension",
                    :path => data_path

  validates_attachment_presence :data
  validates_attachment_size :data, :less_than => 20.megabytes
  #validates_attachment_content_type :data, :content_type => ['audio/mp3']

  define_index do
    indexes title, :sortable => true
    indexes author
    indexes dimension
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

end

