require 'spec_helper'

describe "promo_users/edit" do
  before(:each) do
    @promo_user = assign(:promo_user, stub_model(PromoUser,
      :user_id => 1,
      :promo_idd => 1,
      :code_id => 1
    ))
  end

  it "renders the edit promo_user form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => promo_users_path(@promo_user), :method => "post" do
      assert_select "input#promo_user_user_id", :name => "promo_user[user_id]"
      assert_select "input#promo_user_promo_idd", :name => "promo_user[promo_idd]"
      assert_select "input#promo_user_code_id", :name => "promo_user[code_id]"
    end
  end
end
