class UsersController < ApplicationController

  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user,    :only => [:show, :edit, :update, :cart, :cart_delete_tracks]

  def new
    @user = User.new
  end

  def create
    @user = User.new
    if verify_recaptcha && @user.signup!(params)
      @user.deliver_activation_instructions!
      if !session[:referrer].blank? && (@referrer = User.find(session[:referrer]) )
        @user.referrer = @referrer
        @user.save
        session[:referrer] = nil
      end

      flash[:notice] = "Ваш аккаунт был успешно создан. Пожалуйста, проверьте вашу почту для активации вашего аккаутна!"
      redirect_to root_url
    else
      render :action => :new,  :location => signup_url
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

end

