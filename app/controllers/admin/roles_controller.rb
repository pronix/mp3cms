class Admin::RolesController < ApplicationController
  before_filter :require_user
  filter_resource_access
  inherit_resources
  defaults :resource_class => Role,
           :collection_name => 'roles', :instance_name => 'role'


  respond_to :html, :js


  def create
    create! do |success, failure|
      success.html { redirect_to admin_roles_path }
    end
  end
end
