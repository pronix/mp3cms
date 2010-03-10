class SearchesController < ApplicationController

  def show

  end

  def mp3
    case params[:attribute]
      when "author"
        @rez_search = Track.search :conditions => { :author => params[:search] }
        Lastsearch.create(:search_string => params[:search], :site_attributes => "author", :site_section => "mp3")
      when "title"
        @rez_search = Track.search :conditions => { :title => params[:search] }
        Lastsearch.create(:search_string => params[:search], :site_attributes => "title", :site_section => "mp3")
      when "everywhere"
        @rez_search = Track.search params[:search]
        Lastsearch.create(:search_string => params[:search], :site_attributes => "everywhere", :site_section => "mp3")
      else
        @rez_search = Track.search params[:search]
        Lastsearch.create(:search_string => params[:search], :site_attributes => "everywhere", :site_section => "mp3")
    end
  end

  def playlists
    @rez_search = Playlist.search params[:search]
    Lastsearch.create(:search_string => params[:search], :site_section => "playlist")
  end

  def news
    @rez_search = News.search params[:search]
    Lastsearch.create(:search_string => params[:search], :site_section => "news")
  end

end

