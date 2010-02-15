class Playlist < ActiveRecord::Base
  validates_presence_of :title
  belongs_to :user
  has_many :comments
  has_many :tracks
  acts_as_commentable

  define_index do
    indexes title, :sortable => true
    indexes description
  end

  def owner
    self.user.login
  end

end

