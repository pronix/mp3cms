class NewsItemsController < ApplicationController

  def index
    @news = NewsItem.send(((params[:state] && params[:state][/top|fresh/]) ? params[:state] : "all"
                           ).to_sym ).paginate :page => params[:page], :per_page => 5
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

