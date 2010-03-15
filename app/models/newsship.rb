class Newsship < ActiveRecord::Base
  belongs_to :news_item
  belongs_to :category
end

