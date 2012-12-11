class QuickProperty < ActiveRecord::Base
  attr_accessible :key, :value, :resource_id
  belongs_to :resource_offer

  after_save :update_handler

  private
    def update_handler
      ApplicationController::resource_offer_handler().update_resource_info([self.resource_offer_id])
    end
end
