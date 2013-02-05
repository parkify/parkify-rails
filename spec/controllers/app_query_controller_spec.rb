require 'spec_helper'

describe AppQueryController do

  describe "GET 'user_aquisition_new'" do
    it "returns http success" do
      get 'user_aquisition_new'
      response.should be_success
    end
  end

  describe "GET 'user_aquisition_create'" do
    it "returns http success" do
      get 'user_aquisition_create'
      response.should be_success
    end
  end

end
