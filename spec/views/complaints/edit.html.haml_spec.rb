require 'spec_helper'

describe "complaints/edit" do
  before(:each) do
    @complaint = assign(:complaint, stub_model(Complaint,
      :user_id => 1,
      :resource_offer_id => 1,
      :image_id => 1,
      :description => "MyString",
      :latitude => 1.5,
      :longitude => 1.5,
      :resolved => false
    ))
  end

  it "renders the edit complaint form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => complaints_path(@complaint), :method => "post" do
      assert_select "input#complaint_user_id", :name => "complaint[user_id]"
      assert_select "input#complaint_resource_offer_id", :name => "complaint[resource_offer_id]"
      assert_select "input#complaint_image_id", :name => "complaint[image_id]"
      assert_select "input#complaint_description", :name => "complaint[description]"
      assert_select "input#complaint_latitude", :name => "complaint[latitude]"
      assert_select "input#complaint_longitude", :name => "complaint[longitude]"
      assert_select "input#complaint_resolved", :name => "complaint[resolved]"
    end
  end
end
