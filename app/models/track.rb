class Track < ActiveRecord::Base

  define_index do
    indexes title, :sortable => true
    indexes author
    indexes dimension
    set_property :delta => true, :threshold => 1.hour
  end

end

