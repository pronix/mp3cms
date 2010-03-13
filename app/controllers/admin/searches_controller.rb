class Admin::SearchesController < ApplicationController

  layout "admin"

  def news_items
    unless params[:search_string].nil?
      if params[:search_string].size > 0
        case params[:attribute]
          when "everywhere"
            @rez_search = NewsItem.search params[:search_string]
          when "id"
            @rez_search = NewsItem.search :conditions => { :id => params[:search_string] }
          else
            @rez_search = NewsItem.search params[:search_string]
        end

        unless @rez_search.empty?
          @title = params[:search_string]
        else
          @title = "Новостей с схожих с запросом не найденно"
        end
      else
        @title = "У вас пустой запрос"
      end
    else
      @title = "Поиск по новостям"
    end

  end
end

