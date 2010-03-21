class Admin::SearchesController < ApplicationController

  layout "admin"

# default_behavior в в аргументе метода search говорит о том что мы вышли на страницу без дололнительных аргументов и по дефолту произойдёт выборка "список треков на модерации"
  def show
    if params[:search_track] != ""
      case params[:model]
        when "track"
          @rez_search = Track.search_track(params, page = params[:page], per_page = 10)
          @partial = "track"
        when "playlist"
          @rez_search = Playlist.search_playlist(params, page = params[:page], per_page = 10)
          @partial = "playlist"
        when "news_item"
          @rez_search = NewsItem.search_newsitem(params, page = params[:page], per_page = 10)
          @partial = "news_item"
        when "user"
          @rez_search = User.search_user(params, page = params[:page], per_page = 10)
          @partial = "user"
        when "transaction"
          @rez_search = Transaction.search_transaction(params, page = params[:page], per_page = 10)
          @partial = "transaction"
        else
          @rez_search = Track.search_track("default", page = params[:page], per_page = 10)
          @partial = "track"
      end
    else
      flash[:notice] = "У вас пустой запрос"
    end
  end


end

