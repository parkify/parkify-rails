require 'spec_helper'

describe "price_intervals/new" do
  before(:each) do
    assign(:price_interval, stub_model(PriceInterval,
      :price_per_hour => "",
      :price_plan_id => ""
    ).as_new_record)
  end

  it "renders new price_interval form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => price_intervals_path, :method => "post" do
      assert_select "input#price_interval_price_per_hour", :name => "price_interval[price_per_hour]"
      assert_select "input#price_interval_price_plan_id", :name => "price_interval[price_plan_id]"
    end
  end
end
