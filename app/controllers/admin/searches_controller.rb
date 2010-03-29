class Admin::SearchesController < ApplicationController
  filter_access_to :all, :attribute_check => false


# default_behavior в в аргументе метода search говорит о том что мы вышли на страницу без дололнительных аргументов и по дефолту произойдёт выборка "список треков на модерации"
  def show
    @index = 0
    @partial = (!params[:model].blank? && params[:model][/playlist|news_item|user|transaction/]) ? params[:model] : "track"
    unless params[:search_track].blank?
      @rez_search = case params[:model]
                    when "playlist"    then Playlist.search_playlist(params, per_page = 10)
                    when "news_item"   then NewsItem.search_newsitem(params, per_page = 10)
                    when "user"        then User.search_user(params, per_page = 10)
                    when "transaction" then Transaction.search_transaction(params, per_page = 10)
                    else
                      Track.search_track(params, per_page = 10)
                    end
    else
      @rez_search = nil
      flash[:notice] = "У вас пустой запрос"
    end

  end


end

