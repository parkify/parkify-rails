require 'spec_helper'

describe "offer_schedule_exceptions/show" do
  before(:each) do
    @offer_schedule_exception = assign(:offer_schedule_exception, stub_model(OfferScheduleException,
      :resource_offer_id => 1,
      :exception_type => "Exception Type",
      :duration => 1.5,
      :price => 1.5,
      :capacity => 1.5
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/Exception Type/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
  end
end
