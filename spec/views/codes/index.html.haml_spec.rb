require 'spec_helper'

describe "codes/index" do
  before(:each) do
    assign(:codes, [
      stub_model(Code,
        :code_text => "MyText",
        :personal => false,
        :promo_id => 1
      ),
      stub_model(Code,
        :code_text => "MyText",
        :personal => false,
        :promo_id => 1
      )
    ])
  end

  it "renders a list of codes" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
