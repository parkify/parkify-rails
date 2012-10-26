require "spec_helper"

describe PromosController do
  describe "routing" do

    it "routes to #index" do
      get("/promos").should route_to("promos#index")
    end

    it "routes to #new" do
      get("/promos/new").should route_to("promos#new")
    end

    it "routes to #show" do
      get("/promos/1").should route_to("promos#show", :id => "1")
    end

    it "routes to #edit" do
      get("/promos/1/edit").should route_to("promos#edit", :id => "1")
    end

    it "routes to #create" do
      post("/promos").should route_to("promos#create")
    end

    it "routes to #update" do
      put("/promos/1").should route_to("promos#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/promos/1").should route_to("promos#destroy", :id => "1")
    end

  end
end
