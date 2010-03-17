class Admin::NewsItemsController < ApplicationController

  layout "admin"

  def index
    @news = NewsItem.find(:all, :order => "created_at DESC")
  end

  def show
    @news = NewsItem.find(params[:id])
  end

  def news_list
    news_category = NewsCategory.find(params[:news_category_id])
    @news_items = news_category.news_items
  end

  def edit
    @news = NewsItem.find(params[:id])
  end

  def update
    @news = NewsItem.find(params[:id])
    @news.update_attributes(params[:news_item])
    if @news.save
      flash[:notice] = "Новость обнавленна"
      redirect_to admin_news_items_url
    else
      render :action => "edit"
    end
  end

  def create
    @news = NewsItem.new(params[:news_item])
    if @news.save
      flash[:notice] = "Вы создали новую новость"
      redirect_to admin_news_categories_url
    else
      render :action => "new"
    end
  end

  def new
    @news = NewsItem.new()
  end

  def destroy
    NewsItem.destroy(params[:id])
    redirect_to :back
  end

end

