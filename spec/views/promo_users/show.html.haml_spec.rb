require 'spec_helper'

describe "promo_users/show" do
  before(:each) do
    @promo_user = assign(:promo_user, stub_model(PromoUser,
      :user_id => 1,
      :promo_idd => 2,
      :code_id => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
  end
end
