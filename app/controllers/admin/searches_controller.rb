class Admin::SearchesController < ApplicationController

  layout "admin"

  def playlists
    unless params[:search_string].nil?
      if params[:search_string].size > 0
        case params[:attribute]
          when "login"
            user = User.find_by_login(params[:search_string])
            if user
              @rez_search = Playlist.search :conditions => { :user_id => user.id, :title => params[:search_string] }
            else
              @title = "Пользователь с таким логином не найден"
            end
          when "id"
            @rez_search = Playlist.search :conditions => { :id => params[:search_string] }
            unless @rez_search.empty?
              @title = "Плейлист с таким id не найден"
            end
          when "title"
            @rez_search = Playlist.search :conditions => { :title => params[:search_string] }
            unless @rez_search.empty?
              @title = "Плейлист с таким title не найден"
            end
          else
            @rez_search = Playlist.search :conditions => { :title => params[:search_string] }
            unless @rez_search.empty?
              @title = "Плейлист с таким title не найден"
            end
        end

        unless @rez_search.empty?
          @title = params[:search_string]
        end
      else
        @title = "У вас пустой запрос"
      end
    else
      @title = "Поиск по новостям"
    end
  end

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

