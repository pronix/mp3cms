require 'spec_helper'

describe Admin::TransactionsController do

  #Delete these examples and add some real ones
  it "should use Admin::TransactionsController" do
    controller.should be_an_instance_of(Admin::TransactionsController)
  end


  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end
end
