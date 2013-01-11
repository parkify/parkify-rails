require 'spec_helper'

describe "flat_rate_prices/show" do
  before(:each) do
    @flat_rate_price = assign(:flat_rate_price, stub_model(FlatRatePrice,
      :duration => 1.5,
      :price => 1.5,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/Name/)
  end
end
