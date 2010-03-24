class WelcomeController < ApplicationController

  def index
    @lastrequests = Lastsearch.find(:all, :order => "created_at DESC", :limit => 10)
    @last_news_items = NewsItem.find(:all, :limit => 6)
    # сортируем пока по принципу - новые сверху
    @tracks = Track.active.find(:all, :order => "id DESC", :limit => 5000).paginate(page_options)
  end

  # Статические страницы
  def show
    @page = Page.find params[:path].join('_')
    render :action => :show
  rescue ActiveRecord::RecordNotFound
    render "not_found"
  end
end

