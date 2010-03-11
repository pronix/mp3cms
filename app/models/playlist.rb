class Playlist < ActiveRecord::Base

  belongs_to :user

  define_index do
    indexes title, :sortable => true
    indexes description
  end

  def owner
    self.user.login
  end

end

