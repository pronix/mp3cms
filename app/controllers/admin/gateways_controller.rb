class Admin::GatewaysController < ApplicationController
  before_filter :require_user
  filter_resource_access
  inherit_resources
  defaults :resource_class => Gateway,
           :collection_name => 'gateways', :instance_name => 'gateway'

end
