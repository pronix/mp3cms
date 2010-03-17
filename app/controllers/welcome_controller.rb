class WelcomeController < ApplicationController

  def index
    @lastrequests = Lastsearch.find(:all, :order => "created_at DESC", :limit => 10)
    @last_news_items = NewsItem.find(:all, :order => "created_at DESC", :limit => 6)
  end

end

