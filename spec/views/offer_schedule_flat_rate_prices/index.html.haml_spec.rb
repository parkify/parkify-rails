require 'spec_helper'

describe "offer_schedule_flat_rate_prices/index" do
  before(:each) do
    assign(:offer_schedule_flat_rate_prices, [
      stub_model(OfferScheduleFlatRatePrice),
      stub_model(OfferScheduleFlatRatePrice)
    ])
  end

  it "renders a list of offer_schedule_flat_rate_prices" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
