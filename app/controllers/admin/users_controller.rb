class Admin::UsersController < ApplicationController
  before_filter :require_user
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



end
