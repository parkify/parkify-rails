require 'spec_helper'

describe "devices/show" do
  before(:each) do
    @device = assign(:device, stub_model(Device,
      :device_uid => "Device Uid",
      :push_token_id => "Push Token",
      :device_type => "Device Type"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Device Uid/)
    rendered.should match(/Push Token/)
    rendered.should match(/Device Type/)
  end
end
