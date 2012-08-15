require 'spec_helper'

describe "price_intervals/edit" do
  before(:each) do
    @price_interval = assign(:price_interval, stub_model(PriceInterval,
      :price_per_hour => "",
      :price_plan_id => ""
    ))
  end

  it "renders the edit price_interval form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => price_intervals_path(@price_interval), :method => "post" do
      assert_select "input#price_interval_price_per_hour", :name => "price_interval[price_per_hour]"
      assert_select "input#price_interval_price_plan_id", :name => "price_interval[price_plan_id]"
    end
  end
end
