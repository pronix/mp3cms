class Admin::ServersController < Admin::ApplicationController
  filter_access_to :all, :attribute_check => false

  def index
    respond_to do |format|
      format.html{ }
      format.json { render :json => [].to_json }
    end
  end

end