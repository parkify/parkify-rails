

class OfferScheduleException < ActiveRecord::Base
  attr_accessible :capacity, :duration, :exception_type, :price, :resource_offer_id, :start

  belongs_to :resource_offer
 
  after_save :update_handler
  after_destroy :update_handler


  has_many :offer_schedule_flat_rate_prices, :as => :offer_schedule_flat_rate_priceable
  has_many :flat_rate_prices, :through => :offer_schedule_flat_rate_prices

  def flat_rate_price_hash
    toRtn = {}
    self.flat_rate_prices.each do |flp|
      toRtn[flp.name] = {:duration => flp.duration, :price => flp.price}
    end
    toRtn
  end


  def generate_working_schedule(start_time_in, end_time_in)
    toRtn = {:capacity_intervals => [], :price_intervals => []}
   
    start_time_to_generate = [start_time_in, Time.at(self.start)].max
    end_time_to_generate = [end_time_in, Time.at(self.start + self.duration)].min

    if (end_time_to_generate > start_time_to_generate)
        toRtn[:capacity_intervals] << CapacityInterval.new(start_time_to_generate, end_time_to_generate, self.capacity)
        toRtn[:price_intervals] << PriceInterval.new(start_time_to_generate, end_time_to_generate, self.price, self.flat_rate_price_hash)
    end

    return toRtn
  end

  def update_handler
    if(ResourceOffer.exists?(self.resource_offer_id))
      ResourceOfferContainer::update_spot(self.resource_offer_id, false)
    end
  end

end
