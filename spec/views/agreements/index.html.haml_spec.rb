require 'spec_helper'

describe "agreements/index" do
  before(:each) do
    assign(:agreements, [
      stub_model(Agreement,
        :offer_id => 1,
        :acceptance_id => 2
      ),
      stub_model(Agreement,
        :offer_id => 1,
        :acceptance_id => 2
      )
    ])
  end

  it "renders a list of agreements" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
