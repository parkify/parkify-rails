require 'spec_helper'

describe "offer_schedule_flat_rate_prices/new" do
  before(:each) do
    assign(:offer_schedule_flat_rate_price, stub_model(OfferScheduleFlatRatePrice).as_new_record)
  end

  it "renders new offer_schedule_flat_rate_price form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => offer_schedule_flat_rate_prices_path, :method => "post" do
    end
  end
end
