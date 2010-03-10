class SearchesController < ApplicationController

  def show

  end

  def mp3
    case params[:attribute]
      when "author"
        @rez_search = Track.search :conditions => {:author => params[:avtor]}
      when "title"
        @rez_search = Track.search :conditions => {:author => params[:title]}
      when "everywhere"
        @rez_search = Track.search :conditions => {:author => params[:author], :title => params[:title] }
      else
        @rez_search = Track.search :conditions => {:author => params[:author], :title => params[:title] }
    end
  end

  def playlists
  end

  def news
  end

end

