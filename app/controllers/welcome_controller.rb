class WelcomeController < ApplicationController

  def index
    case params[:state].to_s
    when "top"
      @tracks = Track.active.top_main
    else
      @lastrequests = Lastsearch.latest
      @last_news_items = NewsItem.find(:all, :limit => 6)
      # сортируем пока по принципу - новые сверху
      @tracks = Track.active.latest
      @playlists = Playlist.latest
    end
  end

  # Статические страницы
  def show
    @page = Page.find_by_permalink [params[:path]].flatten.join('/')
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { render "not_found", :status => 404 }
      format.all { render :nothing => true, :status => 404 }
    end
  end
end

