require 'aasm'
#require 'mp3info'
#require 'ruby-mp3info'

class Track < ActiveRecord::Base

  validates_presence_of :playlist_id, :user_id, :data
  belongs_to :playlist
  #after_create :build_mp3_tags

  has_attached_file :data,
                    :url  => "/tracks/:id/:basename.:extension",
                    :path => ":rails_root/data/tracks/:id/:basename.:extension"

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

