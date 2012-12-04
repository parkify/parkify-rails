require 'spec_helper'

describe "cards/index" do
  before(:each) do
    assign(:cards, [
      stub_model(Card,
        :customer_id => "Customer",
        :user_id => 1,
        :active_customer => false,
        :zip_code => "Zip Code",
        :last4 => "Last4"
      ),
      stub_model(Card,
        :customer_id => "Customer",
        :user_id => 1,
        :active_customer => false,
        :zip_code => "Zip Code",
        :last4 => "Last4"
      )
    ])
  end

  it "renders a list of cards" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Customer".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "Zip Code".to_s, :count => 2
    assert_select "tr>td", :text => "Last4".to_s, :count => 2
  end
end
