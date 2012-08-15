require "spec_helper"

describe PriceIntervalsController do
  describe "routing" do

    it "routes to #index" do
      get("/price_intervals").should route_to("price_intervals#index")
    end

    it "routes to #new" do
      get("/price_intervals/new").should route_to("price_intervals#new")
    end

    it "routes to #show" do
      get("/price_intervals/1").should route_to("price_intervals#show", :id => "1")
    end

    it "routes to #edit" do
      get("/price_intervals/1/edit").should route_to("price_intervals#edit", :id => "1")
    end

    it "routes to #create" do
      post("/price_intervals").should route_to("price_intervals#create")
    end

    it "routes to #update" do
      put("/price_intervals/1").should route_to("price_intervals#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/price_intervals/1").should route_to("price_intervals#destroy", :id => "1")
    end

  end
end
