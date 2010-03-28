require 'spec_helper'

describe Mp3CutsController do

  #Delete these examples and add some real ones
  it "should use Mp3CutsController" do
    controller.should be_an_instance_of(Mp3CutsController)
  end


  describe "GET 'show'" do
    it "should be successful" do
      get 'show'
      response.should be_success
    end
  end
end
