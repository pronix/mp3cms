class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user,    :only => [:show, :edit, :update, :cart, :cart_delete_tracks]
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

      flash[:notice] = "Ваш аккаунт был успешно создан. Пожалуйста, проверьте вашу почту для активации вашего аккаутна!"
      #flash[:notice] = "Your account has been created. Please check your e-mail for your account activation instructions!"
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
    @archive = Archive.new
    @try_find_archive = ArchiveLink.find(session[:archive]) rescue nil
    session[:archive] = nil unless @try_find_archive
  end

  def delete_from_cart
    @user = current_user
    if params[:track_ids].to_a.size > 0
      @user.delete_from_cart(params[:track_ids])
      @tracks = @user.cart_tracks.paginate(page_options)
      respond_to do |format|
        format.js { }
      end
    else
      respond_to do |format|
        format.js { @error = true }
      end
    end
  end

  def update
    @user = current_user
    if params[:user][:email]
      @user.reset_perishable_token!
      Notifier.deliver_email_confirmation(@user,params[:user][:email]) if validate_email params[:user][:email]
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

  protected
def validate_email(email)
  email_regex = %r{
    ^ # Start of string
    [0-9a-z_] # First character
    [0-9a-z.+]+ # Middle characters
      [0-9a-z] # Last character
    @ # Separating @ character
    [0-9a-z] # Domain name begin
    [0-9a-z.-]+ # Domain name middle
      [0-9a-z] # Domain name end
$ # End of string
  }xi # Case insensitive
  email =~ email_regex ? true : false
end

end

