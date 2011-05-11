class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new]
  before_filter :require_user, :only => :destroy


  def new
    session[:return_to] = params[:return_to] if params[:return_to]
    @user_session = UserSession.new
    respond_to do |format|
      format.html { }
      format.js { render :partial => "form", :layout => false }
    end
  end

  def redirect

  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash.notice = "Добро пожаловать!"
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js   { render :create }
      end

    else
      respond_to do |format|
        format.html { render :action => :new }
        format.js   { render :action => :new, :layout => false }
      end
    end
  end

  def destroy
    current_user_session.destroy
    redirect_to root_url, :notice => "Надеемся, вы нас ещё посетите!"
  end
end

