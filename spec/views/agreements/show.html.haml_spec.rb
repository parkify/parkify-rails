require 'spec_helper'

describe "agreements/show" do
  before(:each) do
    @agreement = assign(:agreement, stub_model(Agreement,
      :offer_id => 1,
      :acceptance_id => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
  end
end
