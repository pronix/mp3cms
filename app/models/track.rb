require 'aasm'

class Track < ActiveRecord::Base

  validates_presence_of :playlist_id, :user_id

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

    # named_scope :active, :conditions => {:state => "active"}


end

