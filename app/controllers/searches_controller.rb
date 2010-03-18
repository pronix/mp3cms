class SearchesController < ApplicationController

  def show

  end

  def mp3
    if params[:search_mp3].size > 0
      case params[:attribute]
        when "author"
          @rez_search = Track.search :conditions => { :author => params[:search_mp3] }
          Lastsearch.create(:search_string => params[:search_mp3], :site_attributes => "author", :site_section => "mp3")
        when "title"
          @rez_search = Track.search :conditions => { :title => params[:search_mp3] }
          Lastsearch.create(:search_string => params[:search_mp3], :site_attributes => "title", :site_section => "mp3")
        when "everywhere"
          @rez_search = Track.search params[:search_mp3]
          Lastsearch.create(:search_string => params[:search_mp3], :site_attributes => "everywhere", :site_section => "mp3")
        else
          @rez_search = Track.search params[:search_mp3]
          Lastsearch.create(:search_string => params[:search_mp3], :site_attributes => "everywhere", :site_section => "mp3")
      end

      unless @rez_search.empty?
        @title = params[:search_mp3]
      else
        @title = "Фаил не найден в нашей базе попробуйте запросить его в столе заказов"
      end

    else
      @title = "У вас пустой запрос"
    end
  end

  def playlists
    if params[:search_playlist].size > 0
      @rez_search = Playlist.search params[:search_playlist]
      Lastsearch.create(:search_string => params[:search_playlist], :site_section => "playlist")

      unless @rez_search.empty?
        @title = params[:search_playlist]
      else
        @title = "Плейлистов схожих с запросом не найденно"
      end
    else
      @title = "У вас пустой запрос"
    end

  end

  def news
    if params[:search_news].size > 0
      case params[:attribute]
        when "everywhere"
          @rez_search = NewsItem.search params[:search_news]
          Lastsearch.create(:search_string => params[:search_news], :site_section => "news", :site_attributes => "everywhere")
        when "id"
          @rez_search = NewsItem.search :conditions => { :id => params[:search_news] }

          Lastsearch.create(:search_string => params[:search_news], :site_section => "news", :site_attributes => "id" )
        else
          @rez_search = NewsItem.search params[:search_news]
          Lastsearch.create(:search_string => params[:search_news], :site_section => "news", :site_attributes => "everywhere" )
      end

      unless @rez_search.empty?
        @title = params[:search_news]
      else
        @title = "Новостей с схожих с запросом не найденно"
      end
    else
      @title = "У вас пустой запрос"
    end

  end

end

