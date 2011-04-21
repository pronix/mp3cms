class PasswordResetsController < ApplicationController
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]

  def new
    render
  end

  def create
    @user = User.find_by_email(params[:email])
    if @user
      @user.deliver_password_reset_instructions!
      flash[:notice] = "Инструкция по смене пароля отправлена на Вашу электронной почту. Пожалуйста, проверьте свою электронную почту"
      redirect_to root_url
    else
      flash[:notice] = "Учетная запись не найдена."
      render :action => :new
    end
  end

  def edit
    render
  end

  def update
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.valid_updated_password? && @user.save
      flash[:notice] = "Ваш пароль был обновлен"
      redirect_to root_path
    else
      render :action => :edit
    end
  end

  private
  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id], 24.hours)
    unless @user
      flash[:notice] = "Мы сожалеем, но мы не могли найти Вашу учетную запись. Если у вас возникли вопросы, попробуйте скопировать и вставить URL из электронной почты в адресной строке браузера."
      redirect_to root_url
    end
  end
end
