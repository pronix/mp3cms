class Track < ActiveRecord::Base

  define_index do
    indexes title, :sortable => true
    indexes author
    indexes dimension
  end

end

