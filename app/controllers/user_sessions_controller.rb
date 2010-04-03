class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new]
  before_filter :require_user, :only => :destroy


  def new
    session[:return_to] = params[:return_to] if params[:return_to]
    @user_session = UserSession.new
    respond_to do |format|
      format.html { }
      format.js { render :action => "new", :layout => false }
    end
  end

  def create

    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = I18n.t("Добро пожаловать!")
      redirect_back_or_default(root_url)
    else
      render :action => :new, :location => "login"
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = I18n.t("Надеемся, вы нас ещё посетите!")
    redirect_to root_url
  end
end

