class Admin::NewsCategoriesController < ApplicationController

  layout "admin"

  def index
    @news_categories = NewsCategory.find(:all, :order => "created_at DESC")
  end

  def list_news
    @news_category = NewsCategory.find(params[:id])
    @news_items = @news_category.news_items
  end

  def destroy
    NewsCategory.destroy(params[:id])
    redirect_to :back
  end

  def show
    @news_category = NewsCategory.find(params[:id])
  end

  def edit
    @news_category = NewsCategory.find(params[:id])
  end

  def update
    @news_category = NewsCategory.find(params[:id])
    @news_category.update_attributes(params[:news_category])
    if @news_category.save
      flash[:notice] = "Категория новостей обнавленна"
      redirect_to admin_news_categories_url
    else
      render :action => "edit"
    end
  end

  def new
    @news_category = NewsCategory.new
  end

  def create
    @news_category = NewsCategory.new(params[:news_category])
    if @news_category.save
      flash[:notice] = "Созданна новая категория новостей"
      redirect_to admin_news_categories_url
    else
      render :action => "new"
    end
  end
end

