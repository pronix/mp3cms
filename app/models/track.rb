class Track < ActiveRecord::Base

  define_index do
    indexes title
    indexes author
    indexes dimension
  end

end

