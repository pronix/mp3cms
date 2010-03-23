class WelcomeController < ApplicationController

  def index
    @lastrequests = Lastsearch.find(:all, :order => "created_at DESC", :limit => 10)
  end

  def show
    @page = Page.find params[:path].join('_')
    render :action => :show
  rescue ActiveRecord::RecordNotFound
    render "not_found"
  end
end

