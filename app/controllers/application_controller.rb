class ApplicationController < ActionController::Base
  protect_from_forgery



  def self.resource_offer_handler
    RESOURCE_OFFER_HANDLER
  end

  def self.update_resource_info(spots)
    if RESOURCE_OFFER_HANDLER
      resource_offer_handler().update_resource_info(spots)
    end
  end

  def self.update_resource_availability(spots)
    if RESOURCE_OFFER_HANDLER
      resource_offer_handler().update_resource_availability(spots)
    end
  end

end
