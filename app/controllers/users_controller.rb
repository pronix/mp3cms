class UsersController < ApplicationController

  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user,    :only => [:show, :edit, :update, :cart, :cart_delete_tracks]
  before_filter :load_data, :only => [:new, :create]
  before_filter :valid_captcha, :only => [:create]

  def new
    clear_flash
  end

  def create
    if @user.signup!(params)
      @user.deliver_activation_instructions!
      if !session[:referrer].blank? && (@referrer = User.find_by_id(session[:referrer]) )
        @user.referrer = @referrer
        @user.save
        session[:referrer] = nil
      end
      redirect_to root_url, :notice => I18n.t("create_account")
    else
      render :new
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if params[:user] && params[:user][:email].to_s.match(Authlogic::Regex.email)
      Notification.email_confirmation(@user.id,params[:user][:email]).deliver
      flash[:notice] = "На указаный вами адрес отправлено письмо для подтверждения"
      redirect_to account_url
    else
      if @user.update_attributes(params[:user])
        redirect_to account_url
      else
        render :action => "edit"
      end
    end
  end

  private

  def load_data
    @user = User.new(params[:user])
    @user.valid? unless params[:user].blank?
  end

  def valid_captcha
    unless verify_recaptcha
      flash.delete(:recaptcha_error)
      flash[:error] = "Неправильная капча."
      render :new and return
    end
  end

end

