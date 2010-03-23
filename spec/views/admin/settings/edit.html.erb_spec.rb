require 'spec_helper'

describe "/admin/settings/edit" do
  before(:each) do
    render 'admin/settings/edit'
  end

  #Delete this example and add some real ones or delete this file
  it "should tell you where to find the file" do
    response.should have_tag('p', %r[Find me in app/views/admin/settings/edit])
  end
end
