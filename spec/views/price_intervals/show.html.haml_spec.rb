require 'spec_helper'

describe "price_intervals/show" do
  before(:each) do
    @price_interval = assign(:price_interval, stub_model(PriceInterval,
      :price_per_hour => "",
      :price_plan_id => ""
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(//)
  end
end
