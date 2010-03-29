class SearchesController < ApplicationController

  def show
    case params[:model]
      when "playlist"
        @rez_search = Playlist.search_playlist(params, per_page = 10)

        unless @rez_search.empty?
          if params[:remember] == ""
            Lastsearch.add_search(params)
          end
        end

        @params = "playlist"
      when "track"
        @rez_search = Track.user_search_track(params, per_page = 10)
        @tracks = @rez_search

        if @rez_search.empty?
          if params[:remember] == ""
            Lastsearch.create(:url_string => "query[:search_track]", :url_attributes => "author title", :url_model => "track")
          end
        end

        @params = "track"
      when "news_item"
        @rez_search = NewsItem.search_newsitem(params, per_page = 10)

        unless @rez_search.empty?
          if params[:remember] == ""
            Lastsearch.add_search(params)
          end
        end

        @params = "news"
      else
        @rez_search = NewsItem.search_newsitem(params, :page => params)
        @params = "news"
    end
  end

end

