require 'spec_helper'

describe "device_users/new" do
  before(:each) do
    assign(:device_user, stub_model(DeviceUser,
      :device_id => 1,
      :user_id => 1
    ).as_new_record)
  end

  it "renders new device_user form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => device_users_path, :method => "post" do
      assert_select "input#device_user_device_id", :name => "device_user[device_id]"
      assert_select "input#device_user_user_id", :name => "device_user[user_id]"
    end
  end
end
