class Playlist < ActiveRecord::Base
  validates_presence_of :title, :user_id
  belongs_to :user
  has_many :comments
  has_and_belongs_to_many :tracks
  acts_as_commentable

  define_index do
    indexes title, :sortable => true
    indexes description
    indexes id
    indexes user_id
    set_property :delta => true, :threshold => Settings[:delta_index]
  end

  def owner
    self.user.login
  end

end

