require 'spec_helper'

describe AppQueryController do

  describe "GET 'user_aquisition'" do
    it "returns http success" do
      get 'user_aquisition'
      response.should be_success
    end
  end

end
