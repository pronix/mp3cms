class Admin::UsersController < Admin::ApplicationController
  filter_resource_access
  inherit_resources
  defaults :resource_class => User,:collection_name => 'users', :instance_name => 'user'
  respond_to :html, :js

  def new
    new! do |format|
      format.html { render :action => :new }
      format.js   { render :action => :new, :layout => false }
    end
  end

  def edit
    edit! do |format|
      format.html { render :action => :edit }
      format.js   { render :action => :edit, :layout => false }
    end
  end

  def block
    if request.post? && resource.valid_block(params[:user])
      resource.block!(params[:user])
      flash[:notice] = I18n.t('flash.actions.block.notice', :resource_name => User.human_name)
      redirect_to resource_path
    else
      render :action => :block
    end
  end

  def unblock
    resource.unblock!
    flash[:notice] = I18n.t('flash.actions.unblock.notice', :resource_name => User.human_name)
    redirect_to collection_path
  end

end
