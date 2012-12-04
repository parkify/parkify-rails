require 'spec_helper'

describe "offer_schedules/show" do
  before(:each) do
    @offer_schedule = assign(:offer_schedule, stub_model(OfferSchedule,
      :resource_offer_id => 1,
      :recurrance_type => "Recurrance Type",
      :duration => 1.5,
      :price_per_hour => 1.5,
      :capacity => 1.5
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/Recurrance Type/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
  end
end
