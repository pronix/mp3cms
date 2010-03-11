class NewsItem < ActiveRecord::Base

  has_many :pictures, :as => :imageable

  define_index do
    indexes header, :sortable => true
    indexes text
    set_property :delta => true, :threshold => 1.hour
  end

end

