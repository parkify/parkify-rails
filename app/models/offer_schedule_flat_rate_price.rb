class OfferScheduleFlatRatePrice < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :flat_rate_price
  belongs_to :offer_schedule_flat_rate_priceable, :polymorphic => true
end
