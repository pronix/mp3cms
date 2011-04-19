class SearchesController < ApplicationController

  def show
    case params[:model]
    when "playlist"
      search_playlist
    when "track"
      search_track
    else
      search_news
    end

  end

  private

  def search_news
    @rez_search = NewsItem.search_newsitem(params, per_page = 10)
    unless @rez_search.blank?
      Lastsearch.add_search(params) if params[:remember] == ""
    else
      flash[:search_notice] = "Поиск по новостям с текущим запросом не дал результатов, уточните запрос"
    end

    @params = "news"
  end

  def search_track
    if params[:char].blank?
      @rez_search = Track.user_search_track(params, per_page = 10)
      @tracks = @rez_search
      unless @rez_search.blank?
        if params[:remember] == ""
          Lastsearch.create(:url_string => "query[:search_track]", :url_attributes => "author title", :url_model => "track")
        end
      else
        flash[:search_notice] = "Файл #{URI.unescape(params[:q])} не найден в нашей базе, попробуйте запросить его в <a href='/orders'>столе заказов</a>"
      end
    else
      @rez_search = Track.user_search_track(params)
      @tracks = @rez_search
      flash[:search_notice] = "Файлы на заданный символ не найдены" if @rez_search.blank?
    end
    @params = "track"
  end

  def search_playlist
    @rez_search = Playlist.search_playlist(params)

    unless @rez_search.blank?
      Lastsearch.add_search(params) if params[:remember] == ""
    else
      flash[:search_notice] = "Поиск по плей листам с текущим запросом не дал результатов, уточните запрос"
    end
    @params = "playlist"
  end

end

