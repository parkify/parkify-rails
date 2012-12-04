require 'spec_helper'

describe "complaints/show" do
  before(:each) do
    @complaint = assign(:complaint, stub_model(Complaint,
      :user_id => 1,
      :resource_offer_id => 2,
      :image_id => 3,
      :description => "Description",
      :latitude => 1.5,
      :longitude => 1.5,
      :resolved => false
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
    rendered.should match(/Description/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/false/)
  end
end
