require 'spec_helper'

describe "flat_rate_prices/edit" do
  before(:each) do
    @flat_rate_price = assign(:flat_rate_price, stub_model(FlatRatePrice,
      :duration => 1.5,
      :price => 1.5,
      :name => "MyString"
    ))
  end

  it "renders the edit flat_rate_price form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => flat_rate_prices_path(@flat_rate_price), :method => "post" do
      assert_select "input#flat_rate_price_duration", :name => "flat_rate_price[duration]"
      assert_select "input#flat_rate_price_price", :name => "flat_rate_price[price]"
      assert_select "input#flat_rate_price_name", :name => "flat_rate_price[name]"
    end
  end
end
