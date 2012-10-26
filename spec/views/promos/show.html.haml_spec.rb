require 'spec_helper'

describe "promos/show" do
  before(:each) do
    @promo = assign(:promo, stub_model(Promo,
      :name => "MyText",
      :description => "MyText",
      :type => "MyText",
      :value1 => 1.5,
      :value2 => 1.5
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
  end
end
