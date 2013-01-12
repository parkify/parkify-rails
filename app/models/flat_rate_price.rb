class FlatRatePrice < ActiveRecord::Base
  attr_accessible :duration, :name, :price

  has_many :offer_schedule_flat_rate_prices
  has_many :offer_schedule_flat_rate_priceables, :through => :offer_schedule_flat_rate_prices

end
