require "spec_helper"

describe OfferScheduleFlatRatePricesController do
  describe "routing" do

    it "routes to #index" do
      get("/offer_schedule_flat_rate_prices").should route_to("offer_schedule_flat_rate_prices#index")
    end

    it "routes to #new" do
      get("/offer_schedule_flat_rate_prices/new").should route_to("offer_schedule_flat_rate_prices#new")
    end

    it "routes to #show" do
      get("/offer_schedule_flat_rate_prices/1").should route_to("offer_schedule_flat_rate_prices#show", :id => "1")
    end

    it "routes to #edit" do
      get("/offer_schedule_flat_rate_prices/1/edit").should route_to("offer_schedule_flat_rate_prices#edit", :id => "1")
    end

    it "routes to #create" do
      post("/offer_schedule_flat_rate_prices").should route_to("offer_schedule_flat_rate_prices#create")
    end

    it "routes to #update" do
      put("/offer_schedule_flat_rate_prices/1").should route_to("offer_schedule_flat_rate_prices#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/offer_schedule_flat_rate_prices/1").should route_to("offer_schedule_flat_rate_prices#destroy", :id => "1")
    end

  end
end
