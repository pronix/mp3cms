class Admin::NewsItemsController < ApplicationController

  filter_access_to :all, :attribute_check => false


  def approve
    @news = NewsItem.find(params[:id])
    @news.update_attribute(:state, "active")
    @news.save
    redirect_to :back
  end

  def index
    if params[:attribute].blank?
      @news = NewsItem.active.paginate(:page => params[:page], :per_page => 10)
    else
      @news = NewsItem.moderation.paginate(:page => params[:page], :per_page => 10)
    end
  end

  def show
    @news = NewsItem.find(params[:id])
  end


  def edit
    @news = NewsItem.find(params[:id])
  end

  def update
    @news = NewsItem.find(params[:id])
    @news.update_attributes(params[:news_item])
    @news.update_attribute(:user_id, current_user.id)
    if @news.save
      0.upto(9) do |index|
        unless params["newsimage_#{index}"].blank?
          @news.newsimages.create! params["newsimage_#{index}"]
        end
      end
      flash[:notice] = "Новость обнавленна"
      redirect_to admin_news_items_url
    else
      render :action => "edit"
    end
  end

  def create
    @news = NewsItem.new(params[:news_item])
    if current_user.admin?
      @news.state = "active"
    else
      @news.state = "moderation"
    end
    if @news.valid?
      @news.update_attribute(:user_id, current_user.id)
      0.upto(9) do |index|
        unless params["newsimage_#{index}"].blank?
          @news.newsimages.create! params["newsimage_#{index}"]
        end
      end
      @news.save
      flash[:notice] = "Вы создали новую новость"
      redirect_to admin_news_items_url
    else
      render :action => "new"
    end
  end

  def deleteimage
    Newsimage.delete(params[:id])
    redirect_to :back
  end

  def new
    @news = NewsItem.new
  end

  def destroy
    news = NewsItem.find(params[:id])
    news.destroy
    flash[:notice] = "Новость была удалена"
    redirect_to :back
  end

end

