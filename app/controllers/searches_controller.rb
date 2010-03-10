class SearchesController < ApplicationController

  def show

  end

  def mp3
    case params[:attribute]
      when "author"
        @rez_search = Track.search :conditions => { :author => params[:search] }
      when "title"
        @rez_search = Track.search :conditions => { :title => params[:search] }
      when "everywhere"
        @rez_search = Track.search params[:search]
      else
        @rez_search = Track.search params[:search]
    end
  end

  def playlists
    @rez_search = Playlist.search params[:search]
  end

  def news
    @rez_search = News.search params[:search]
  end

end

