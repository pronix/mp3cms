require 'spec_helper'

describe Admin::SettingsController do

  #Delete these examples and add some real ones
  it "should use Admin::SettingsController" do
    controller.should be_an_instance_of(Admin::SettingsController)
  end


  describe "GET 'show'" do
    it "should be successful" do
      get 'show'
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    it "should be successful" do
      get 'edit'
      response.should be_success
    end
  end
end
