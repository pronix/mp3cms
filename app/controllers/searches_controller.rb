class SearchesController < ApplicationController

  def show
    case params[:model]
      when "playlist"
        @rez_search = Playlist.search_playlist(params, per_page = 10)

        unless @rez_search.empty?
          Lastsearch.add_search(params)
        end

        @params = "playlist"
      when "track"
        @rez_search = Track.search_track(params, per_page = 10)

        unless @rez_search.empty?
          Lastsearch.add_search(params)
        end

        @params = "track"
      when "news_item"
        @rez_search = NewsItem.search_newsitem(params, per_page = 10)

        unless @rez_search.empty?
          Lastsearch.add_search(params)
        end

        @params = "news"
      else
        @rez_search = NewsItem.search_newsitem(params, :page => params)
        @params = "news"
    end
  end

end

