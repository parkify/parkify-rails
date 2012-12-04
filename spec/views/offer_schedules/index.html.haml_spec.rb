require 'spec_helper'

describe "offer_schedules/index" do
  before(:each) do
    assign(:offer_schedules, [
      stub_model(OfferSchedule,
        :resource_offer_id => 1,
        :recurrance_type => "Recurrance Type",
        :duration => 1.5,
        :price_per_hour => 1.5,
        :capacity => 1.5
      ),
      stub_model(OfferSchedule,
        :resource_offer_id => 1,
        :recurrance_type => "Recurrance Type",
        :duration => 1.5,
        :price_per_hour => 1.5,
        :capacity => 1.5
      )
    ])
  end

  it "renders a list of offer_schedules" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Recurrance Type".to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
  end
end
