class WelcomeController < ApplicationController

  def index
    @lastrequests = Lastsearch.find(:all, :order => "created_at DESC", :limit => 10)
  end

end

