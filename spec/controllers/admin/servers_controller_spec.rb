require 'spec_helper'

describe Admin::ServersController do

  #Delete these examples and add some real ones
  it "should use Admin::ServersController" do
    controller.should be_an_instance_of(Admin::ServersController)
  end


  describe "GET 'show'" do
    it "should be successful" do
      get 'show'
      response.should be_success
    end
  end
end
