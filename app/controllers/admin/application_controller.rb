class Admin::ApplicationController < ApplicationController
  before_filter :require_user
  layout "application"

  protected

end

