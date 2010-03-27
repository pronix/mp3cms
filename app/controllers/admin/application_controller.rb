class Admin::ApplicationController < ApplicationController
  before_filter :require_user
  layout "application"

  protected

  def find_user
    @user = current_user
  end

end

