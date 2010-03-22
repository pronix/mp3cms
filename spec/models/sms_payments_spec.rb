require 'spec_helper'

describe SmsPayments do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    SmsPayments.create!(@valid_attributes)
  end
end
