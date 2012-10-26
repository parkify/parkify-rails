require 'spec_helper'

describe "codes/new" do
  before(:each) do
    assign(:code, stub_model(Code,
      :code_text => "MyText",
      :personal => false,
      :promo_id => 1
    ).as_new_record)
  end

  it "renders new code form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => codes_path, :method => "post" do
      assert_select "textarea#code_code_text", :name => "code[code_text]"
      assert_select "input#code_personal", :name => "code[personal]"
      assert_select "input#code_promo_id", :name => "code[promo_id]"
    end
  end
end
