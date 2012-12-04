require 'spec_helper'

describe "devices/new" do
  before(:each) do
    assign(:device, stub_model(Device,
      :device_uid => "MyString",
      :push_token_id => "MyString",
      :device_type => "MyString"
    ).as_new_record)
  end

  it "renders new device form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => devices_path, :method => "post" do
      assert_select "input#device_device_uid", :name => "device[device_uid]"
      assert_select "input#device_push_token_id", :name => "device[push_token_id]"
      assert_select "input#device_device_type", :name => "device[device_type]"
    end
  end
end
