require "spec_helper"

describe AgreementsController do
  describe "routing" do

    it "routes to #index" do
      get("/agreements").should route_to("agreements#index")
    end

    it "routes to #new" do
      get("/agreements/new").should route_to("agreements#new")
    end

    it "routes to #show" do
      get("/agreements/1").should route_to("agreements#show", :id => "1")
    end

    it "routes to #edit" do
      get("/agreements/1/edit").should route_to("agreements#edit", :id => "1")
    end

    it "routes to #create" do
      post("/agreements").should route_to("agreements#create")
    end

    it "routes to #update" do
      put("/agreements/1").should route_to("agreements#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/agreements/1").should route_to("agreements#destroy", :id => "1")
    end

  end
end
