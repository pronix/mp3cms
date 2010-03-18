# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  helper_method :current_user_session, :current_user
  filter_parameter_logging :password, :password_confirmation
  before_filter :set_current_user
  before_filter :set_referrer

  def permission_denied
    flash[:error] = "Sorry, you are not allowed to access that page."
    redirect_to root_path
  end

  private
  # Установка referrer в сессию
  # Если пользователь не авторизован и
  # в урле есть параметр u(ид пользователя)
  # то записываем в сессию
  def set_referrer
    session[:referrer] = params[:u] if !current_user && !params[:u].blank?
  end

  def set_current_user
    Authorization.current_user = current_user
  end


  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && !current_user_session.record.ban? &&
      current_user_session.record
  end

  def require_user
    unless current_user
      store_location
        flash[:notice] = "You must be logged in to access this page"
      redirect_to login_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to root_path
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def find_user
    @user = current_user
  end

end

