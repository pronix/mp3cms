class WelcomeController < ApplicationController

  def index
    @lastrequests = Lastsearch.find(:all, :order => "created_at DESC", :limit => 10)
<<<<<<< HEAD:app/controllers/welcome_controller.rb
    @last_news_items = NewsItem.find(:all, :order => "created_at DESC", :limit => 6)
=======
    # сортируем пока по принципу - новые сверху
    @tracks = Track.active.find(:all, :order => "id DESC", :limit => 5000).paginate(page_options)
>>>>>>> 1c7883cdc56a409f7fddba0ac10c7658cfc0f886:app/controllers/welcome_controller.rb
  end

end

