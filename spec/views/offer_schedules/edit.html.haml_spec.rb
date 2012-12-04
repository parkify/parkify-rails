require 'spec_helper'

describe "offer_schedules/edit" do
  before(:each) do
    @offer_schedule = assign(:offer_schedule, stub_model(OfferSchedule,
      :resource_offer_id => 1,
      :recurrance_type => "MyString",
      :duration => 1.5,
      :price_per_hour => 1.5,
      :capacity => 1.5
    ))
  end

  it "renders the edit offer_schedule form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => offer_schedules_path(@offer_schedule), :method => "post" do
      assert_select "input#offer_schedule_resource_offer_id", :name => "offer_schedule[resource_offer_id]"
      assert_select "input#offer_schedule_recurrance_type", :name => "offer_schedule[recurrance_type]"
      assert_select "input#offer_schedule_duration", :name => "offer_schedule[duration]"
      assert_select "input#offer_schedule_price_per_hour", :name => "offer_schedule[price_per_hour]"
      assert_select "input#offer_schedule_capacity", :name => "offer_schedule[capacity]"
    end
  end
end
