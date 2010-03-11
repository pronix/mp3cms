class NewsItemsController < ApplicationController

  def index
    @news = NewsItem.find(:all, :order => "created_at DESC")
  end

  def show
    @news = NewsItem.find(params[:id])
  end

end

