class Admin::SearchesController < ApplicationController

  layout "admin"

# default_behavior в в аргументе метода search говорит о том что мы вышли на страницу без дололнительных аргументов и по дефолту произойдёт выборка "список треков на модерации"
  def show
    if params[:search_track] != ""
      case params[:model]
        when "track"
          @rez_search = Track.search_track(params)
          @partial = "track"
        when "playlist"
          @rez_search = Playlist.search_playlist(params)
          @partial = "playlist"
        when "news_item"
          @rez_search = NewsItem.search_newsitem(params)
          @partial = "news_item"
        else
          @rez_search = Track.search_track("default")
          @partial = "track"
      end
    else
      flash[:notice] = "У вас пустой запрос"
    end
  end


end

