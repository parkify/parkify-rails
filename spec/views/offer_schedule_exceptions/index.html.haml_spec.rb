require 'spec_helper'

describe "offer_schedule_exceptions/index" do
  before(:each) do
    assign(:offer_schedule_exceptions, [
      stub_model(OfferScheduleException,
        :resource_offer_id => 1,
        :exception_type => "Exception Type",
        :duration => 1.5,
        :price => 1.5,
        :capacity => 1.5
      ),
      stub_model(OfferScheduleException,
        :resource_offer_id => 1,
        :exception_type => "Exception Type",
        :duration => 1.5,
        :price => 1.5,
        :capacity => 1.5
      )
    ])
  end

  it "renders a list of offer_schedule_exceptions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Exception Type".to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
  end
end
