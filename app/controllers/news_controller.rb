class NewsController < ApplicationController

  def index
    @news = News.find(:all, :order => "created_at DESC")
  end

  def show
    @news = News.find(params[:id])
  end

end

