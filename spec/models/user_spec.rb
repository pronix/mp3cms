require 'spec_helper'

describe User do
  before(:each) do
    @valid_attributes = {

    }

  end

  it "should create a new instance given valid attributes" do
    User.create!(@valid_attributes)
  end
  it "должен создавать учетную запись пользователя с правильными данными"
  it "не должен создавать учетную запись пользователя если не указан email"
end
