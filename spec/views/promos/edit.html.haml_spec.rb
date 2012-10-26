require 'spec_helper'

describe "promos/edit" do
  before(:each) do
    @promo = assign(:promo, stub_model(Promo,
      :name => "MyText",
      :description => "MyText",
      :type => "MyText",
      :value1 => 1.5,
      :value2 => 1.5
    ))
  end

  it "renders the edit promo form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => promos_path(@promo), :method => "post" do
      assert_select "textarea#promo_name", :name => "promo[name]"
      assert_select "textarea#promo_description", :name => "promo[description]"
      assert_select "textarea#promo_type", :name => "promo[type]"
      assert_select "input#promo_value1", :name => "promo[value1]"
      assert_select "input#promo_value2", :name => "promo[value2]"
    end
  end
end
