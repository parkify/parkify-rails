class QuickProperty < ActiveRecord::Base
  #attr_accessible :key, :value, :resource_id
  belongs_to :resource_offer

  after_save :update_handler
  after_destroy :update_handler
  
  def update_handler
    if(ResourceOffer.exists?(self.resource_offer_id))
      ResourceOfferContainer::update_spot(self.resource_offer_id, false)
    end
  end
end
