

GENERATED_INTERVAL_CAP = 500

class OfferSchedule < ActiveRecord::Base
  attr_accessible :capacity, :duration, :end_date, :price_per_hour, :recurrance_type, :relative_start, :resource_offer_id, :start_date

  belongs_to :resource_offer

  after_save :update_handler
  after_destroy :update_handler

  def generate_working_schedule(start_time_in, end_time_in)
    toRtn = {:capacity_intervals => [], :price_intervals => []}
   
    #restrict our window based on this schedule's start and end time.
    if(self.start_date != nil)
      start_time_in = [start_time_in, self.start_date].max
    end
  
    if(self.end_date != nil)
      end_time_in = [end_time_in, self.end_date].min
    end

    if end_time_in <= start_time_in
      return toRtn
    end

    if self.recurrance_type == "None"
      # now restrict generated interval and add
      start_time_to_generate = [start_time_in, Time.at(self.relative_start)].max
      end_time_to_generate = [end_time_in, Time.at(self.relative_start + self.duration)].min

      if (end_time_to_generate > start_time_to_generate)
        toRtn[:capacity_intervals] << CapacityInterval.new(start_time_to_generate, end_time_to_generate, self.capacity)
        toRtn[:price_intervals] << PriceInterval.new(start_time_to_generate, end_time_to_generate, self.price_per_hour)
      end

    else
      next_iter = start_time_in
      start_time_iter = self.recurrance_window_start(next_iter)
      end_time_iter = self.recurrance_window_end(next_iter)

      GENERATED_INTERVAL_CAP.times do |i|
        start_time_iter_restricted = [start_time_iter, start_time_in].max
        end_time_iter_restricted = [end_time_iter, end_time_in].min
        
        if (end_time_iter_restricted <= start_time_iter_restricted)
          break
        end


        start_time_to_generate = start_time_iter+self.relative_start
        end_time_to_generate = start_time_to_generate+self.duration

        # now restrict generated interval and add
        start_time_to_generate = [start_time_iter_restricted, start_time_to_generate].max
        end_time_to_generate = [end_time_iter_restricted, end_time_to_generate].min

        if (end_time_to_generate > start_time_to_generate)
          toRtn[:capacity_intervals] << CapacityInterval.new(start_time_to_generate, end_time_to_generate, self.capacity)
          toRtn[:price_intervals] << PriceInterval.new(start_time_to_generate, end_time_to_generate, self.price_per_hour)
        end
        
        # iterate
        next_iter = end_time_iter+(end_time_iter-start_time_iter)/2
        start_time_iter = self.recurrance_window_start(next_iter)
        end_time_iter = self.recurrance_window_end(next_iter)
      end
    end
    return toRtn
  end


  def recurrance_window_start(time)
    if self.recurrance_type == "Day"
      return time.beginning_of_day
    elsif self.recurrance_type == "Week"
      return time.beginning_of_week
    elsif self.recurrance_type == "Month"
      return time.beginning_of_month
    else
      return Time.at(0)
    end
  end

  def recurrance_window_end(time)
    if self.recurrance_type == "Day"
      return (time.beginning_of_day + 1.5.days).beginning_of_day
    elsif self.recurrance_type == "Week"
      return (time.beginning_of_week + 1.5.weeks).beginning_of_week
    elsif self.recurrance_type == "Month"
      return (time.beginning_of_month + 1.5.months).beginning_of_month
    else
      return Time.at(0)
    end
  end

private
    def update_handler
      ApplicationController::resource_offer_handler().update_resource_availability([self.resource_offer_id])
    end

end



