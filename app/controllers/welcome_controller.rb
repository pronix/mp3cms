class WelcomeController < ApplicationController

  def index
    @lastrequests = Lastsearch.find(:all, :order => "created_at DESC", :limit => 10)
  end

  def show
    @page = Page.find params[:path].join('_')
  end
end

