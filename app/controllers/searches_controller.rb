class SearchesController < ApplicationController

  def show
      case params[:model]
        when "playlist"
          @rez_search = Playlist.search_playlist(params, per_page = 10)

          unless @rez_search.empty?
            if params[:remember] == ""
              Lastsearch.add_search(params)
            end
          else
            flash[:search_notice] = "Поиск по плей листам с текущим запросом не дал результатов, уточните запрос"
          end
          @params = "playlist"

        when "track"

          if params[:char].blank?
            @rez_search = Track.user_search_track(params, per_page = 10)
            @tracks = @rez_search
            unless @rez_search.empty?
              if params[:remember] == ""
                Lastsearch.create(:url_string => "query[:search_track]", :url_attributes => "author title", :url_model => "track")
              end
            else
              flash[:search_notice] = "Файл #{URI.unescape(params[:q])} не найден в нашей базе, попробуйте запросить его в <a href='/orders'>столе заказов</a>"
            end
            @params = "track"
          else
            @rez_search = Track.user_search_track(params, per_page = 10)
            @tracks = @rez_search
            flash[:search_notice] = "Файлы на заданный символ не найдены"
          end

        when "news_item"
          @rez_search = NewsItem.search_newsitem(params, per_page = 10)

          unless @rez_search.empty?
            if params[:remember] == ""
              Lastsearch.add_search(params)
            end
          else
            flash[:search_notice] = "Поиск по новостям с текущим запросом не дал результатов, уточните запрос"
          end

          @params = "news"
        else
          @rez_search = NewsItem.search_newsitem(params, :page => params)
          @params = "news"
      end
  end

end

