class Playlist < ActiveRecord::Base
  validates_presence_of :title
  belongs_to :user
  has_many :comments
  acts_as_commentable

  define_index do
    indexes title, :sortable => true
    indexes description
    set_property :delta => true, :threshold => 1.hour
  end

  def owner
    self.user.login
  end

end

