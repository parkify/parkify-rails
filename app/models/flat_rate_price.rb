class FlatRatePrice < ActiveRecord::Base
  attr_accessible :duration, :name, :price

  has_many :offer_schedule_flat_rate_prices

  has_many :offer_schedules, :through => :offer_schedule_flat_rate_prices, :source => :offer_schedule_flat_rate_priceable, :source_type => 'OfferSchedule'
  has_many :offer_schedule_exceptions, :through => :offer_schedule_flat_rate_prices, :source => :offer_schedule_flat_rate_priceable, :source_type => 'OfferScheduleException'


  after_save :update_handler
  after_destroy :update_handler

  #has_many :offer_schedule_flat_rate_priceables, :through => :offer_schedule_flat_rate_prices

  
  def update_handler
    self.offer_schedule_flat_rate_prices.each do |o|
      o.update_handler
    end
  end

end
