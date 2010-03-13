class SearchesController < ApplicationController

  def show

  end

  def mp3
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

  end

  def playlists
    @rez_search = Playlist.search params[:search_playlist]
    Lastsearch.create(:search_string => params[:search_playlist], :site_section => "playlist")

    unless @rez_search.empty?
      @title = params[:search_playlist]
    else
      @title = "Новостей с схожих с запросом не найденно"
    end

  end

  def news
    @rez_search = NewsItem.search params[:search_news]
    Lastsearch.create(:search_string => params[:search_news], :site_section => "news")
    unless @rez_search.empty?
      @title = params[:search_news]
    else
      @title = "Новостей с схожих с запросом не найденно"
    end

  end

end

