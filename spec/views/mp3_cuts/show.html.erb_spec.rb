require 'spec_helper'

describe "/mp3_cuts/show" do
  before(:each) do
    render 'mp3_cuts/show'
  end

  #Delete this example and add some real ones or delete this file
  it "should tell you where to find the file" do
    response.should have_tag('p', %r[Find me in app/views/mp3_cuts/show])
  end
end
