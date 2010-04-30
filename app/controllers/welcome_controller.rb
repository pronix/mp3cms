class WelcomeController < ApplicationController

  layout "application"

  def index
    @lastrequests = Lastsearch.find(:all, :order => "created_at DESC", :limit => 10)
    @last_news_items = NewsItem.find(:all, :limit => 6)
    # сортируем пока по принципу - новые сверху
    @tracks = Track.active.find(:all, :order => "id DESC", :limit => 10)
    @playlists = Playlist.find(:all, :order => "created_at DESC", :limit => 8)
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

