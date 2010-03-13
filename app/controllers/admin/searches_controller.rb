class Admin::SearchesController < ApplicationController

  layout "admin"

  def mp3
    unless params[:search_string].nil?
      if params[:search_string].size > 0
        case params[:attribute]
          when "login"
            user = User.find_by_login(params[:search_string])
            if user
              @rez_search = Track.search :conditions => { :user_id => user.id }
            else
              @title = "Мп3 с таким битрейтом в сервисе не существует"
            end
          when "id"
            @rez_search = Track.search :conditions => { :id => params[:search_string] }
            if @rez_search.empty?
              @title = "Мп3 с таким id не существует"
            end
          when "title"
            @rez_search = Track.search :conditions => { :title => params[:search_string] }
            if @rez_search.empty?
              @title = "Мп3 с запрошенным вами заголовком не найденны"
            end
          when "more"
            @rez_search = Track.find(:all, :conditions => ["dimension > ?", params[:search_string].to_i])
            if @rez_search.empty?
              @title = "Mp3 с размером большим чем вы указали не найденны"
            end
          when "less"
            @rez_search = Track.search :conditions => { :title => params[:search_string] }
            if @rez_search.empty?
              @title = "Mp3 с размером меньшем чем вы указали не найденны"
            end
          when "well"
            @rez_search = Track.search :conditions => { :title => params[:search_string] }
            if @rez_search.empty?
              @title = "Mp3 с указанным размером не найденны"
            end
          when "bitrate"
            @rez_search = Track.search :conditions => { :title => params[:search_string] }
            if @rez_search.empty?
              @title = "mp3 пользователя с таким логином не найденны"
            end
          else
            @rez_search = Track.search :conditions => { :title => params[:search_string] }
            if @rez_search.empty?
              @title = "Mp3 с таким title не найден"
            end
        end

        if @rez_search
          unless @rez_search.empty?
            @title ||= params[:search_string]
          end
        end

      else
        @title = "У вас пустой запрос"
      end
    else
      @title = "Поиск по мп3"
    end
  end

  def playlists
    unless params[:search_string].nil?
      if params[:search_string].size > 0
        case params[:attribute]
          when "login"
            user = User.find_by_login(params[:search_string])
            if user
              @rez_search = Playlist.search :conditions => { :user_id => user.id }
            else
              @title = "Пользователь с таким логином не найден"
            end
          when "id"
            @rez_search = Playlist.search :conditions => { :id => params[:search_string] }
            if @rez_search.empty?
              @title = "Плейлист с таким id не найден"
            end
          when "title"
            @rez_search = Playlist.search :conditions => { :title => params[:search_string] }
            if @rez_search.empty?
              @title = "Плейлист с таким title не найден"
            end
          else
            @rez_search = Playlist.search :conditions => { :title => params[:search_string] }
            if @rez_search.empty?
              @title = "Плейлист с таким title не найден"
            end
        end

        if @rez_search
          unless @rez_search.empty?
            @title ||= params[:search_string]
          end
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

