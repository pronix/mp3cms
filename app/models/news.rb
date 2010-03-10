class News < ActiveRecord::Base

  define_index do
    indexes header, :sortable => true
    indexes text
  end

end

