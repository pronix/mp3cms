class NewsItemsController < ApplicationController

  def index
    respond_to do |format|
      format.html{
        @news = NewsItem.send(params[:state].present? ? params[:state].to_sym : :all ).
        paginate(:page => params[:page], :per_page => 5)
      }
      format.rss  {
        @news = NewsItem.order("created_at DESC")
        render :layout => false
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

