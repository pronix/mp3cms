class WelcomeController < ApplicationController

  def index
    @lastrequests = Lastsearch.latest
    @last_news_items = NewsItem.find(:all, :limit => 6)
    # сортируем пока по принципу - новые сверху
    @tracks = Track.active.latest
    @playlists = Playlist.latest
  end

  # Статические страницы
  def show
    begin
    @page = Page.find params[:path].join('_')
  rescue
    @page = Page.new
  end
    render :action => :show
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { render "not_found", :status => 404 }
      format.all { render :nothing => true, :status => 404 }
    end
  end
end

