class NewsItemsController < ApplicationController

  def index
    unless params[:attr].blank?
      case params[:attr]
        when "new" # новые ранжируются по дате добавления
          @news = NewsItem.search :order => "created_at DESC", :page => params[:page], :per_page => 10
        when "all" # все - поимени
          @news = NewsItem.search :order => :header, :page => params[:page], :per_page => 10
        when "popular"
          @news = NewsItem.search :order => :header, :page => params[:page], :per_page => 10
      end
    else
      @news = NewsItem.search :order => :header, :page => params[:page], :per_page => 10
    end

    respond_to do |format|
      format.html
      format.rss  { render :action => :index, :layout => false }
      format.atom { render :action => :index, :layout => false }
    end
  end

  def show
    @news = NewsItem.find(params[:id])
    @comments = @news.comments
    @comment = Comment.new
  end


end

