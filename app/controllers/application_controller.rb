class ApplicationController < ActionController::Base
  protect_from_forgery



  def self.resource_offer_handler
    RESOURCE_OFFER_HANDLER
  end

end
