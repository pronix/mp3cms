class NewsItemsController < ApplicationController

  def index
    @news = NewsItem.find(:all, :order => "created_at DESC")
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

