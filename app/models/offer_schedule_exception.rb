

class OfferScheduleException < ActiveRecord::Base
  attr_accessible :capacity, :duration, :exception_type, :price, :resource_offer_id, :start

  belongs_to :resource_offer
 
  after_save :update_handler
  after_destroy :update_handler

  def generate_working_schedule(start_time_in, end_time_in)
    toRtn = {:capacity_intervals => [], :price_intervals => []}
   
    start_time_to_generate = [start_time_in, Time.at(self.start)].max
    end_time_to_generate = [end_time_in, Time.at(self.start + self.duration)].min

    if (end_time_to_generate > start_time_to_generate)
        toRtn[:capacity_intervals] << CapacityInterval.new(start_time_to_generate, end_time_to_generate, self.capacity)
        toRtn[:price_intervals] << PriceInterval.new(start_time_to_generate, end_time_to_generate, self.price)
    end

    return toRtn
  end

  private
    def update_handler
      ApplicationController::resource_offer_handler().update_resource_availability([self.resource_offer_id])
    end


end
