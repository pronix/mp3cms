class Admin::ApplicationController < ApplicationController

  def page_options(count_per_page = 10)
    @page = (params[:page] || 1).to_i
    @page = 1 if @page < 1
    @per_page = (RAILS_ENV=='test' ? 2 : count_per_page).to_i
    { :per_page => @per_page, :page => @page }
  end

end

