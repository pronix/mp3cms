class Admin::SettingsController < Admin::ApplicationController
  filter_access_to :all, :attribute_check => false
  inherit_resources
  defaults :resource_class => AppSetting,
           :collection_name => 'app_settings', :instance_name => 'app_setting'
  actions :index, :edit, :update
  respond_to :html, :js

  def update
    update! do |success, failure|
      success.html {
        flash[:notice] = I18n.t("flash.settings.update.notice")
        redirect_to collection_path }
    end
  end

end
