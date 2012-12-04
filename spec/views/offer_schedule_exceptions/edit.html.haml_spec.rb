require 'spec_helper'

describe "offer_schedule_exceptions/edit" do
  before(:each) do
    @offer_schedule_exception = assign(:offer_schedule_exception, stub_model(OfferScheduleException,
      :resource_offer_id => 1,
      :exception_type => "MyString",
      :duration => 1.5,
      :price => 1.5,
      :capacity => 1.5
    ))
  end

  it "renders the edit offer_schedule_exception form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => offer_schedule_exceptions_path(@offer_schedule_exception), :method => "post" do
      assert_select "input#offer_schedule_exception_resource_offer_id", :name => "offer_schedule_exception[resource_offer_id]"
      assert_select "input#offer_schedule_exception_exception_type", :name => "offer_schedule_exception[exception_type]"
      assert_select "input#offer_schedule_exception_duration", :name => "offer_schedule_exception[duration]"
      assert_select "input#offer_schedule_exception_price", :name => "offer_schedule_exception[price]"
      assert_select "input#offer_schedule_exception_capacity", :name => "offer_schedule_exception[capacity]"
    end
  end
end
