require "spec_helper"

describe OfferSchedulesController do
  describe "routing" do

    it "routes to #index" do
      get("/offer_schedules").should route_to("offer_schedules#index")
    end

    it "routes to #new" do
      get("/offer_schedules/new").should route_to("offer_schedules#new")
    end

    it "routes to #show" do
      get("/offer_schedules/1").should route_to("offer_schedules#show", :id => "1")
    end

    it "routes to #edit" do
      get("/offer_schedules/1/edit").should route_to("offer_schedules#edit", :id => "1")
    end

    it "routes to #create" do
      post("/offer_schedules").should route_to("offer_schedules#create")
    end

    it "routes to #update" do
      put("/offer_schedules/1").should route_to("offer_schedules#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/offer_schedules/1").should route_to("offer_schedules#destroy", :id => "1")
    end

  end
end
