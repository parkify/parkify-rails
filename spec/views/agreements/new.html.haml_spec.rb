require 'spec_helper'

describe "agreements/new" do
  before(:each) do
    assign(:agreement, stub_model(Agreement,
      :offer_id => 1,
      :acceptance_id => 1
    ).as_new_record)
  end

  it "renders new agreement form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => agreements_path, :method => "post" do
      assert_select "input#agreement_offer_id", :name => "agreement[offer_id]"
      assert_select "input#agreement_acceptance_id", :name => "agreement[acceptance_id]"
    end
  end
end
