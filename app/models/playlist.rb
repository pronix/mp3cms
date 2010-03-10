class Playlist < ActiveRecord::Base

  define_index do
    indexes title, :sortable => true
    indexes description
  end

end

