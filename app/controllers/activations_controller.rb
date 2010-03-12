class ActivationsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  def new
    @user = User.find_using_perishable_token(params[:activation_code], Settings[:account_activation_time].days)
    flash[:error] = "Срок регистрации истек"  if @user.blank?
    flash[:error] = "Учетная запись уже активирована" if @user && @user.active?
    render :action => "error_activate" unless flash[:error].blank?
  end

  def create
    @user = User.find(params[:id])

    raise Exception if @user.active?

    if @user.activate!
      @user.deliver_activation_confirmation!
      flash[:notice] = "Your account has been activated."
      redirect_to root_path
    else
      render :action => :new
    end
  end

end
