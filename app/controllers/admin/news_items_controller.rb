class Admin::NewsController < ApplicationController

  layout "admin"

  def index
    @news = NewsItem.find(:all, :order => "created_at DESC")
  end

  def show
    @news = NewsItem.find(params[:id])
  end

  def edit
    @news = NewsItem.find(params[:id])
  end

  def update
    @news = NewsItem.find(params[:id])
    @news.update_attributes(params[:news])
    if @news.save
      flash[:notice] = "Новость обнавленна"
      redirect_to :action => "index"
    else
      render :action => "edit"
    end
  end

  def create
    @news = NewsItem.new(params[:news])
    if @news.save
      flash[:notice] = "Вы создали новую новость"
      redirect_to :admin_news_url
    else
      render :action => "new"
    end
  end

  def new
    @news = NewsItem.new()
  end

  def destroy
    News.destroy(params[:id])
    redirect_to :back
  end

end

