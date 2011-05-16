class Lastsearch < ActiveRecord::Base
  scope :latest, lambda{ |*args| order("created_at DESC").limit(args.first || 10) }

  scope :for_tag_cloud, select("count(*) as count_items, url_string, url_attributes, url_model").
                        group("url_string, url_attributes, url_model").
                        order("count_items DESC").
                        limit(21)

  define_index do
    indexes url_string
    has created_at
    has updated_at
    set_property :delta => true, :threshold => Settings.delta_index
  end

  class << self

    # Создание поиска по автору и титлу - at
    def create_at(str,at='at')
      # строка ниже в зависимости от того что в параметре at  ищет по авторам(если at содержит a) или по титлам(если at содержит t)
      atr = "author title".split.collect {|x| x if x =~ /^#{at.split('').join('|')}/}.join(' ').gsub(/^\s|\s$/,'')
      create!(:url_string => str, :url_attributes => atr, :url_model => "track")
    end

    def delete_old_rows
      rez = where(:created_at => 5.year.ago..1.week.ago)
      destroy(rez) unless rez.blank?
    end


    def add_search(query)
      rez = search(:conditions => {:url_string => query[:url_string], :model => query[:model]})

      case query[:model]
      when "track"
        if query[:attribute] =~ /author|everywhere|title/
          unless query[:search_track].blank?
            create(:url_model => query[:model], :url_string => query[:search_track],
                   :url_attributes => query[:attribute],  :num => rez.size )
          end
        end
      when "playlist"
        unless query[:search_playlist].blank?
          create(:url_model => query[:model], :url_string => query[:search_playlist], :num => rez.size )
        end
      when "news_item"
        unless query[:search_news].blank?
          create(:url_model => query[:model], :url_string => query[:search_news], :num => rez.size )
        end
      end
    end
  end # end class << self
end

