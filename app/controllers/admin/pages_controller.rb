class Admin::PagesController < Admin::ApplicationController
  filter_access_to :all, :attribute_check => false
  inherit_resources
  defaults :resource_class => Page, :collection_name => 'pages', :instance_name => 'page'
  respond_to :html, :js

  def create
    create! do |success, failure|
      success.html {
        flash[:notice] = I18n.t("flash.page.create.notice")
        redirect_to collection_path }
    end
  end


  def update
    update! do |success, failure|
      success.html {
        flash[:notice] = I18n.t("flash.page.update.notice")
        redirect_to collection_path }
    end
  end

  def destroy
    destroy!(:notice => I18n.t("flash.page.destroy.notice"))
  end

  def edit
    @page = Page.find(params[:id])
  end

end
