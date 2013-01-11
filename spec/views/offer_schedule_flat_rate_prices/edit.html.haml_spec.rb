require 'spec_helper'

describe "offer_schedule_flat_rate_prices/edit" do
  before(:each) do
    @offer_schedule_flat_rate_price = assign(:offer_schedule_flat_rate_price, stub_model(OfferScheduleFlatRatePrice))
  end

  it "renders the edit offer_schedule_flat_rate_price form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => offer_schedule_flat_rate_prices_path(@offer_schedule_flat_rate_price), :method => "post" do
    end
  end
end
