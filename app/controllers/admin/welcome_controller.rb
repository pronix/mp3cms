class Admin::WelcomeController < ApplicationController

  filter_access_to :all, :attribute_check => false

  layout "admin"

  def index
  end

end

