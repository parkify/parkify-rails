require 'spec_helper'

describe "complaints/index" do
  before(:each) do
    assign(:complaints, [
      stub_model(Complaint,
        :user_id => 1,
        :resource_offer_id => 2,
        :image_id => 3,
        :description => "Description",
        :latitude => 1.5,
        :longitude => 1.5,
        :resolved => false
      ),
      stub_model(Complaint,
        :user_id => 1,
        :resource_offer_id => 2,
        :image_id => 3,
        :description => "Description",
        :latitude => 1.5,
        :longitude => 1.5,
        :resolved => false
      )
    ])
  end

  it "renders a list of complaints" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
