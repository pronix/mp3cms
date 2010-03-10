class SearchesController < ApplicationController

  def show

  end

  def mp3
    case params[:attribute]
      when "author"
        Track.search :conditions => {:author => params[:avtor]}
      when "title"
        Track.search :conditions => {:author => params[:title]}
      when "everywhere"
        Track.search :conditions => {:author => params[:author], :title => params[:title] }
      else
        Track.search :conditions => {:author => params[:author], :title => params[:title] }
    end
  end

  def playlists
  end

  def news
  end

end

