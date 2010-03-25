class Lastsearch < ActiveRecord::Base

  def self.add_search(query)

    rez = self.search :conditions => {:url_string => query[:url_string], :model => query[:model]}

    case query[:model]
      when "track"
        if query[:attribute] == "author" or query[:attribute] == "everywhere" or query[:attribute] == "title"
          unless query[:search_track].empty?
            self.create(:url_model => query[:model], :url_string => query[:search_track], :url_attributes => query[:attribute], :num => rez.size )
          end
        end
      when "playlist"
        unless query[:search_playlist].empty?
          self.create(:url_model => query[:model], :url_string => query[:search_playlist], :num => rez.size )
        end
      when "news_item"
        unless query[:search_news].empty?
          self.create(:url_model => query[:model], :url_string => query[:search_news], :num => rez.size )
        end
    end
  end

end

