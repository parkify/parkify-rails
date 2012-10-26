require 'spec_helper'

describe "codes/show" do
  before(:each) do
    @code = assign(:code, stub_model(Code,
      :code_text => "MyText",
      :personal => false,
      :promo_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    rendered.should match(/false/)
    rendered.should match(/1/)
  end
end
