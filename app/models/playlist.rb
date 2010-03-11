class Playlist < ActiveRecord::Base

  define_index do
    indexes title, :sortable => true
    indexes description
    set_property :delta => true, :threshold => 1.hour
  end

end

