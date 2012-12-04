require 'spec_helper'

describe "cards/edit" do
  before(:each) do
    @card = assign(:card, stub_model(Card,
      :customer_id => "MyString",
      :user_id => 1,
      :active_customer => false,
      :zip_code => "MyString",
      :last4 => "MyString"
    ))
  end

  it "renders the edit card form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => cards_path(@card), :method => "post" do
      assert_select "input#card_customer_id", :name => "card[customer_id]"
      assert_select "input#card_user_id", :name => "card[user_id]"
      assert_select "input#card_active_customer", :name => "card[active_customer]"
      assert_select "input#card_zip_code", :name => "card[zip_code]"
      assert_select "input#card_last4", :name => "card[last4]"
    end
  end
end
