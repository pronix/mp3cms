class ActivationsController < ApplicationController
  before_filter :require_no_user, :only => [:create]

  def create
    @user = User.find_using_perishable_token(params[:activation_code], Settings.account_activation_time.days)
    flash[:error] = I18n.t('not_found_code_activation') unless @user.present?
    flash[:error] = I18n.t('account_already_activated') if @user.try(:active?)

    if @user.activate!
      @user.deliver_activation_confirmation!
      UserSession.create(@user, true)
      flash[:notice] = I18n.t('acount_activated')
    end

    redirect_to root_path
  end


  def actemail
    @user = User.find_by_persistence_token(params[:token])
    if @user
      @user.reset_persistence_token!
      @user.email = (params[:email])
      @user.save!
      flash[:notice] = 'Email изменен'
    else
      flash[:notice] = 'Код активации неправильный.'
    end
    redirect_to '/'
  end

end

