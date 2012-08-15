require 'spec_helper'

describe "agreements/edit" do
  before(:each) do
    @agreement = assign(:agreement, stub_model(Agreement,
      :offer_id => 1,
      :acceptance_id => 1
    ))
  end

  it "renders the edit agreement form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => agreements_path(@agreement), :method => "post" do
      assert_select "input#agreement_offer_id", :name => "agreement[offer_id]"
      assert_select "input#agreement_acceptance_id", :name => "agreement[acceptance_id]"
    end
  end
end
