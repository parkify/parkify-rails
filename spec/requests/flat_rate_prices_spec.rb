require 'spec_helper'

describe "FlatRatePrices" do
  describe "GET /flat_rate_prices" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get flat_rate_prices_path
      response.status.should be(200)
    end
  end
end
