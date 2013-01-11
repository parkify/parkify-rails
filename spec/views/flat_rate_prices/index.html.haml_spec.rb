require 'spec_helper'

describe "flat_rate_prices/index" do
  before(:each) do
    assign(:flat_rate_prices, [
      stub_model(FlatRatePrice,
        :duration => 1.5,
        :price => 1.5,
        :name => "Name"
      ),
      stub_model(FlatRatePrice,
        :duration => 1.5,
        :price => 1.5,
        :name => "Name"
      )
    ])
  end

  it "renders a list of flat_rate_prices" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
