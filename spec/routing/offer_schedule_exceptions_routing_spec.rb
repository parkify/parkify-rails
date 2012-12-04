require "spec_helper"

describe OfferScheduleExceptionsController do
  describe "routing" do

    it "routes to #index" do
      get("/offer_schedule_exceptions").should route_to("offer_schedule_exceptions#index")
    end

    it "routes to #new" do
      get("/offer_schedule_exceptions/new").should route_to("offer_schedule_exceptions#new")
    end

    it "routes to #show" do
      get("/offer_schedule_exceptions/1").should route_to("offer_schedule_exceptions#show", :id => "1")
    end

    it "routes to #edit" do
      get("/offer_schedule_exceptions/1/edit").should route_to("offer_schedule_exceptions#edit", :id => "1")
    end

    it "routes to #create" do
      post("/offer_schedule_exceptions").should route_to("offer_schedule_exceptions#create")
    end

    it "routes to #update" do
      put("/offer_schedule_exceptions/1").should route_to("offer_schedule_exceptions#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/offer_schedule_exceptions/1").should route_to("offer_schedule_exceptions#destroy", :id => "1")
    end

  end
end
