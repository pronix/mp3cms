require 'spec_helper'

describe Admin::PagesController do

  #Delete these examples and add some real ones
  it "should use Admin::PagesController" do
    controller.should be_an_instance_of(Admin::PagesController)
  end


  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "should be successful" do
      get 'show'
      response.should be_success
    end
  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    it "should be successful" do
      get 'edit'
      response.should be_success
    end
  end

  describe "GET '_form'" do
    it "should be successful" do
      get '_form'
      response.should be_success
    end
  end
end
