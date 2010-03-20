class Admin::GatewaysController < Admin::ApplicationController
  filter_resource_access
  inherit_resources
  defaults :resource_class => Gateway,
           :collection_name => 'gateways', :instance_name => 'gateway'
  def update
    update! do |success, failure|
      success.html {
        flash[:notice] = I18n.t("flash.gateways.update.notice",
                         :resource_name => resource.class.to_s.demodulize)
        redirect_to collection_path }
    end
  end
end
