class AccountController < ApplicationController
  before_filter :require_user
  inherit_resources
  actions :show, :edit, :update
  defaults :resource_class => User, :collection_name => 'users', :instance_name => 'user', :singleton => true
  respond_to :html, :js

  def edit
    edit! do |format|
      format.html { render :action => :edit }
      format.js   { render :action => :edit, :layout => false }
    end
  end

  def update
    update!(:notice => I18n.t("Account_was_successfully_updated")) do |success, failure|
      success.html { redirect_to account_path }
      failure.html {
        flash[:error] = resource.errors.full_messages.join(", ")
        redirect_to account_path }
    end
  end

  protected
  def resource
    current_user
  end

end
