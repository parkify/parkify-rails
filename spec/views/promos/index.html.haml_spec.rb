require 'spec_helper'

describe "promos/index" do
  before(:each) do
    assign(:promos, [
      stub_model(Promo,
        :name => "MyText",
        :description => "MyText",
        :type => "MyText",
        :value1 => 1.5,
        :value2 => 1.5
      ),
      stub_model(Promo,
        :name => "MyText",
        :description => "MyText",
        :type => "MyText",
        :value1 => 1.5,
        :value2 => 1.5
      )
    ])
  end

  it "renders a list of promos" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
  end
end
