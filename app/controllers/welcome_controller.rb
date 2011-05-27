class WelcomeController < ApplicationController

  def index
    @playlists = Playlist.latest
    @last_news_items = NewsItem.fresh.limit(6)
    @lastrequests = Lastsearch.latest

    case params[:state].to_s
    when "top"
      @tracks = Track.top_mp3(Settings.limit_on_root_page)
    else
      @tracks = Track.active.latest
    end
    save_tracks_to_session(@tracks)
  end

  # Статические страницы
  def show
    unless @page = Page.find_by_permalink([params[:path]].flatten.join('/'))
      respond_to do |format|
        format.html { render "not_found", :status => 404 }
        format.all { render :nothing => true, :status => 404 }
      end
    end
  end
end

