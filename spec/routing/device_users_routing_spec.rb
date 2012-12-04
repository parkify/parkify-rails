require "spec_helper"

describe DeviceUsersController do
  describe "routing" do

    it "routes to #index" do
      get("/device_users").should route_to("device_users#index")
    end

    it "routes to #new" do
      get("/device_users/new").should route_to("device_users#new")
    end

    it "routes to #show" do
      get("/device_users/1").should route_to("device_users#show", :id => "1")
    end

    it "routes to #edit" do
      get("/device_users/1/edit").should route_to("device_users#edit", :id => "1")
    end

    it "routes to #create" do
      post("/device_users").should route_to("device_users#create")
    end

    it "routes to #update" do
      put("/device_users/1").should route_to("device_users#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/device_users/1").should route_to("device_users#destroy", :id => "1")
    end

  end
end
