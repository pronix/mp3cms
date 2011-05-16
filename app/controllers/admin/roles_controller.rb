class Admin::RolesController < Admin::ApplicationController
  filter_resource_access
  inherit_resources
  defaults :resource_class => Role,
           :collection_name => 'roles', :instance_name => 'role'


  respond_to :html, :js


  def create
    @role = Role.new(params[:role])
    @role.valid?
    if @role.save
      flash[:notice] =  I18n.t("flash.role.create.notice")
      redirect_to admin_roles_path
    else
      render :new
    end
    # create! do |success, failure|
    #   success.html {
    #     redirect_to admin_roles_path , :notice => I18n.t("flash.role.create.notice")}
    #   failure.html{ render :new }
    # end
  end
  def update
    update! do |success, failure|
      success.html {
        flash[:notice] = I18n.t("flash.role.update.notice")
        redirect_to admin_roles_path }
    end
  end
  def destroy
    destroy!(:notice => I18n.t("flash.role.destroy.notice"))
  end
end
