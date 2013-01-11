require 'spec_helper'

describe "offer_schedule_flat_rate_prices/show" do
  before(:each) do
    @offer_schedule_flat_rate_price = assign(:offer_schedule_flat_rate_price, stub_model(OfferScheduleFlatRatePrice))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
