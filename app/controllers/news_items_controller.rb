class NewsItemsController < ApplicationController

  def index

    if request.format.html?
      @news = NewsItem.send(((params[:state] && params[:state][/top|fresh/]) ? params[:state] : "all"
                             ).to_sym ).paginate :page => params[:page], :per_page => 5
    else
      @news = NewsItem.find(:all, :order => "created_at DESC")
    end
    
    respond_to do |format|
      format.html
      format.rss  { render :layout => false
        response.headers["Content-Type"] = "application/xml; charset=utf-8"

      }
    end
  end


  def show
    @news = NewsItem.find(params[:id])
    @comments = @news.comments.paginate(:page => params[:page], :per_page => 10)
    @comment = Comment.new
  end


end

