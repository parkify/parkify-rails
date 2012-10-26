require 'spec_helper'

describe "promo_users/index" do
  before(:each) do
    assign(:promo_users, [
      stub_model(PromoUser,
        :user_id => 1,
        :promo_idd => 2,
        :code_id => 3
      ),
      stub_model(PromoUser,
        :user_id => 1,
        :promo_idd => 2,
        :code_id => 3
      )
    ])
  end

  it "renders a list of promo_users" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
