class Admin::ApplicationController < ApplicationController
  before_filter :require_user
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  layout "admin"

  protected

end

