require 'spec_helper'

describe "devices/index" do
  before(:each) do
    assign(:devices, [
      stub_model(Device,
        :device_uid => "Device Uid",
        :push_token_id => "Push Token",
        :device_type => "Device Type"
      ),
      stub_model(Device,
        :device_uid => "Device Uid",
        :push_token_id => "Push Token",
        :device_type => "Device Type"
      )
    ])
  end

  it "renders a list of devices" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Device Uid".to_s, :count => 2
    assert_select "tr>td", :text => "Push Token".to_s, :count => 2
    assert_select "tr>td", :text => "Device Type".to_s, :count => 2
  end
end
