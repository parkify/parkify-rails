require "spec_helper"

describe ComplaintsController do
  describe "routing" do

    it "routes to #index" do
      get("/complaints").should route_to("complaints#index")
    end

    it "routes to #new" do
      get("/complaints/new").should route_to("complaints#new")
    end

    it "routes to #show" do
      get("/complaints/1").should route_to("complaints#show", :id => "1")
    end

    it "routes to #edit" do
      get("/complaints/1/edit").should route_to("complaints#edit", :id => "1")
    end

    it "routes to #create" do
      post("/complaints").should route_to("complaints#create")
    end

    it "routes to #update" do
      put("/complaints/1").should route_to("complaints#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/complaints/1").should route_to("complaints#destroy", :id => "1")
    end

  end
end
