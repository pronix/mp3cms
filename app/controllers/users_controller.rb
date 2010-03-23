class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user,    :only => [:show, :edit, :update, :cart]
  validates_captcha_of User, :only => [:create]

  def new
    @user = User.new
  end

  def create
    @user = User.new
    if @user.signup!(params)
      @user.deliver_activation_instructions!
      if !session[:referrer].blank? && (@referrer = User.find(session[:referrer]) )
        @user.referrer = @referrer
        @user.save
        session[:referrer] = nil
      end

      flash[:notice] = "Your account has been created. Please check your e-mail for your account activation instructions!"
        redirect_to root_url
    else
      render :action => :new,  :location => signup_url
    end
  end

  def edit
    @user = current_user
  end

  def cart
    @user = current_user
    @tracks = @user.cart_tracks.paginate(page_options)
  end

  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      redirect_to dashboard_url
    else
      render :action => "edit"
    end
  end

end

