class ApplicationController < ActionController::Base
  protect_from_forgery



  def self.resource_offer_handler 
    if !RESOURCE_OFFER_HANDLER && !ENV["PENDING_MIGRATIONS"]
      RESOURCE_OFFER_HANDLER = ResourceOfferHandler.make_singleton
    end
    RESOURCE_OFFER_HANDLER
  end

  def self.update_resource_info(spots)
    if resource_offer_handler()
      resource_offer_handler().update_resource_info(spots)
    end
  end

  def self.update_resource_availability(spots)
    if resource_offer_handler()
      resource_offer_handler().update_resource_availability(spots)
    end
  end

end
