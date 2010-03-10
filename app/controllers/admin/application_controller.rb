class Admin::ApplicationController < ApplicationController

  #filter_access_to :all

  before_filter :find_user
  before_filter :set_current_user

  helper :all # include all helpers, all the time
  include AuthenticatedSystem
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  rescue_from Authorization::NotAuthorized, :with => :permission_denied

  protected

  def find_user
    begin
      @user = current_user
    rescue
      permission_denied
    end
  end

  def find_site
    begin
      @site = @user.site
    rescue
      permission_denied
    end
  end

  def set_current_user
    Authorization.current_user = current_user
  end

  def permission_denied
    if current_user
      flash[:error] = I18n.t(:access_denied)
      redirect_to(:back, :status => :forbidden) rescue redirect_to(root_path, :status => :forbidden)
    else
      flash[:error] = I18n.t(:login_require)
      redirect_to(login_path, :status => :forbidden)
    end
  end

  def page_options(count_per_page = 10)
    @page = (params[:page] || 1).to_i
    @page = 1 if @page < 1
    @per_page = (RAILS_ENV=='test' ? 2 : count_per_page).to_i
    { :per_page => @per_page, :page => @page }
  end

  def paginate_options(key = 'per_page')
    @page = (params[:page] || 1).to_i
    @page = 1 if @page < 1
    per_page = SETTINGS[key].to_i
    { :per_page => per_page, :page => @page }
  end

end
