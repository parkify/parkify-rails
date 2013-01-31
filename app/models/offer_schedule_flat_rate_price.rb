class OfferScheduleFlatRatePrice < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :flat_rate_price
  belongs_to :offer_schedule_flat_rate_priceable, :polymorphic => true

  after_save :update_handler
  after_destroy :update_handler

  def update_handler
    self.offer_schedule_flat_rate_pricable.update_handler
  end

end
