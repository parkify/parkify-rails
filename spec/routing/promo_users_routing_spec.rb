require "spec_helper"

describe PromoUsersController do
  describe "routing" do

    it "routes to #index" do
      get("/promo_users").should route_to("promo_users#index")
    end

    it "routes to #new" do
      get("/promo_users/new").should route_to("promo_users#new")
    end

    it "routes to #show" do
      get("/promo_users/1").should route_to("promo_users#show", :id => "1")
    end

    it "routes to #edit" do
      get("/promo_users/1/edit").should route_to("promo_users#edit", :id => "1")
    end

    it "routes to #create" do
      post("/promo_users").should route_to("promo_users#create")
    end

    it "routes to #update" do
      put("/promo_users/1").should route_to("promo_users#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/promo_users/1").should route_to("promo_users#destroy", :id => "1")
    end

  end
end
