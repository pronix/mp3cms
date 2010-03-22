class Lastsearch < ActiveRecord::Base

  def self.add_search(query)
    case query[:model]
      when "track"
        if query[:attribute] == "author" or query[:attribute] == "everywhere" or query[:attribute] == "title"
          unless query[:search_track].empty?
            self.create(:url_model => query[:model], :url_string => query[:search_track], :url_attributes => query[:attribute] )
          end
        end
      when "playlist"
        unless query[:search_playlist].empty?
          self.create(:url_model => query[:model], :url_string => query[:search_playlist] )
        end
      when "news_item"
        unless query[:search_news].empty?
          self.create(:url_model => query[:model], :url_string => query[:search_news] )
        end
    end
  end

end

