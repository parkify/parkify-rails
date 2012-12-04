require 'spec_helper'

describe "cards/show" do
  before(:each) do
    @card = assign(:card, stub_model(Card,
      :customer_id => "Customer",
      :user_id => 1,
      :active_customer => false,
      :zip_code => "Zip Code",
      :last4 => "Last4"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Customer/)
    rendered.should match(/1/)
    rendered.should match(/false/)
    rendered.should match(/Zip Code/)
    rendered.should match(/Last4/)
  end
end
