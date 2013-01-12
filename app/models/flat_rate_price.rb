class FlatRatePrice < ActiveRecord::Base
  attr_accessible :duration, :name, :price

  has_many :offer_schedule_flat_rate_prices

  has_many :offer_schedules, :through => :offer_schedule_flat_rate_prices, :source => :offer_schedule_flat_rate_priceable, :source_type => 'OfferSchedule'
  has_many :offer_schedule_exceptions, :through => :offer_schedule_flat_rate_prices, :source => :offer_schedule_flat_rate_priceable, :source_type => 'OfferScheduleException'


  #has_many :offer_schedule_flat_rate_priceables, :through => :offer_schedule_flat_rate_prices

end
