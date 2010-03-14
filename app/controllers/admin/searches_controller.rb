class Admin::SearchesController < ApplicationController

  layout "admin"

  def user
    unless params[:search_string].nil?
      if params[:search_string].size > 0
        case params[:attribute]
          when "login"
            @rez_search = User.search :conditions => { :login => params[:search_string] }
            if @rez_search.empty?
              @title = "Пользователь с таким логином не найден"
            end
          when "email"
            @rez_search = User.search :conditions => { :email => params[:search_string] }
            if @rez_search.empty?
              @title = "Пользователь с таким email не найден"
            end
          when "balance"
            @rez_search = User.search :conditions => { :balance => params[:search_string] }
            if @rez_search.empty?
              @title = "Пользователи с таким балансом не найден"
            end
          when "ip"
            @rez_search = User.find(:all, :conditions => ["last_login_ip = ?", params[:search_string]])
            @rez_search2 = User.find(:all, :conditions => ["current_login_ip = ?", params[:search_string]])
            @rez_search = @rez_search + @rez_search2
            @rez_search.uniq!
            if @rez_search.empty?
              @title = "Пользователи с таким ip не найден"
            end
          when "id"
            @rez_search = User.search :conditions => { :id => params[:search_string] }
            if @rez_search.empty?
              @title = "Пользователи с таким ID не найден"
            end
          else
            @rez_search = User.search :conditions => { :title => params[:search_string] }
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
      @title = "Поиск по пользователям"
    end
  end

  def mp3
    unless params[:search_string].nil?
      if params[:search_string].size > 0
        case params[:attribute]
          when "author"
            if params[:state] == "all"
              @rez_search = Track.search :conditions => { :author => params[:search_string]}
            else
              @rez_search = Track.search :conditions => { :author => params[:search_string], :state => params[:state] }
            end

            if @rez_search.empty?
              @title = "Мп3 с таким автором не существует"
            end
          when "login"
            user = User.find_by_login(params[:search_string])
            if user
              if params[:state] == "all"
                @rez_search = Track.search :conditions => { :user_id => user.id }
              else
                @rez_search = Track.search :conditions => { :user_id => user.id, :state => params[:state] }
              end

            else
              @title = "Мп3 с таким битрейтом в сервисе не существует"
            end
          when "id"
            if params[:state] == "all"
              @rez_search = Track.search :conditions => { :id => params[:search_string] }
            else
              @rez_search = Track.search :conditions => { :id => params[:search_string], :state => params[:state] }
            end

            if @rez_search.empty?
              @title = "Мп3 с таким id не существует"
            end
          when "title"
            if params[:state] == "all"
              @rez_search = Track.search :conditions => { :title => params[:search_string] }
            else
              @rez_search = Track.search :conditions => { :title => params[:search_string], :state => params[:state] }
            end

            if @rez_search.empty?
              @title = "Мп3 с запрошенным вами заголовком не найденны"
            end
          when "more"
            if params[:state] == "all"
              @rez_search = Track.find(:all, :conditions => ["dimension > ?", params[:search_string].to_i])
            else
              @rez_search = Track.find(:all, :conditions => ["dimension > ? AND state = ?", params[:search_string].to_i, params[:state]])
            end

            if @rez_search.empty?
              @title = "Mp3 с размером большим чем вы указали не найденны"
            end
          when "less"
            if params[:state] == "all"
              @rez_search = Track.find(:all, :conditions => ["dimension < ?", params[:search_string].to_i])
            else
              @rez_search = Track.find(:all, :conditions => ["dimension < ?", params[:search_string].to_i, params[:state]])
            end

            if @rez_search.empty?
              @title = "Mp3 с размером меньшем чем вы указали не найденны"
            end
          when "well"
            if params[:state] == "all"
              @rez_search = Track.find(:all, :conditions => ["dimension = ?", params[:search_string].to_i])
            else
              @rez_search = Track.find(:all, :conditions => ["dimension = ?", params[:search_string].to_i, params[:state]])
            end

            if @rez_search.empty?
              @title = "Mp3 с указанным размером не найденны"
            end
          when "bitrate"
            if params[:state] == "all"
              @rez_search = Track.search :conditions => { :bitrate => params[:search_string] }
            else
              @rez_search = Track.search :conditions => { :bitrate => params[:search_string], :state => params[:state] }
            end

            if @rez_search.empty?
              @title = "mp3 с таким bitrate не найденны"
            end
          else
            @rez_search = Track.search :conditions => { :title => params[:search_string], :state => params[:state]  }
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
      @title = "Поиск по плейлистам"
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

