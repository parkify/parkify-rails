RESOURCE_OFFER_HANDLER_WINDOW_WIDTH = 1.week

# Not an ActiveRecord object. Builds and updates an in-memory schedule for spots.
class ResourceOfferHandler
  
  def initialize(options={})
    @resources = {}
    @activeresources = {}
    if options[:only]
      options[:only].each do |ro_id|
        @resources[ro_id] = ResourceOfferContainer.new(ResourceOffer.find_by_id(ro, options))
      end
    else
      ResourceOffer.all.each do |ro|
        @resources[ro.id] = ResourceOfferContainer.new(ro, options)
        if (ro["active"]==true)
          @activeresources[ro.id] = @resources[ro.id]
        end
      end
    end
  end

  def update_resource_info(resource_offers)
    resource_offers.each do |ro|
      if !@resources[ro]
        @resources[ro] = ResourceOfferContainer.new(ResourceOffer.find_by_id(ro))
      else
        @resources[ro].update_info()
      end
    end
  end

  def update_resource_availability(resource_offers)
    resource_offers.each do |ro|
      if !@resources[ro]
        @resources[ro] = ResourceOfferContainer.new(ResourceOffer.find_by_id(ro))
      else
        @resources[ro].update_availability()
      end
    end
  end
  
  def retrieve_spots(options={})
    
    if options[:all]
      return @resources.values
    elsif options[:active]
      return @activeresources
    elsif options[:only]
      return options[:only].map{|x| @resources[x]}
    else
      return []
    end
  end

  def validate_reservation(resource_offer_id, start_time, end_time)
    resource_offer_container = self.resources[resource_offer_id]
    if(resource_offer_container == nil)
      return false
    else
      return resource_offer_container.validate_reservation(start_time, end_time)
    end
  end

  def validate_reservation_and_find_price(resource_offer_id, start_time, end_time)
    resource_offer_container = self.resources[resource_offer_id]
    if(resource_offer_container == nil)
      return -1
    else
      return resource_offer_container.validate_reservation_and_find_price(start_time, end_time)
    end
  end

  def self.validate_reservation_and_find_price(resource_offer_id, start_time, end_time)
    fresh_container = ResourceOfferContainer.new(ResourceOffer.find_by_id(resource_offer_id), {:start_time=>start_time, :end_time=>end_time, :no_update_info=>true})
    return fresh_container.validate_reservation_and_find_price(start_time, end_time)
  end

  def self.validate_reservation(resource_offer_id, start_time, end_time)
    fresh_container = ResourceOfferContainer.new(ResourceOffer.find_by_id(resource_offer_id), {:start_time=>start_time, :end_time=>end_time, :no_update_info=>true})
    return fresh_container.validate_reservation(start_time, end_time)
  end
end

class ResourceOfferContainer
  attr_accessor :resource
  attr_accessor :price_intervals
  attr_accessor :capacity_intervals
  attr_accessor :totalprice_interval
  attr_accessor :totalcapacity_interval
  def initialize(resource, options={})
    @resource = resource
    @price_intervals = []
    @capacity_intervals = []
    @totalprice_interval =[]
    @totalcapacity_interval=[]
    update_availability(options[:start_time], options[:end_time], options[:no_update_info])
  end

  def update_info
    @resource.reload
  end

  # update both price and capacity intervals
  def update_availability(start_time=nil, end_time=nil, no_update_info=nil)
    #Quick fix so we can access correct schedule info.
    #TODO: replace accessing of schedule info with a direct sql query.
    if !no_update_info
      update_info 
    end

    @capacity_intervals = []
    @price_intervals = []
    @totalprice_interval =[]
    @totalcapacity_interval=[]

    # I specify a window with which to generate a working schedule.
    if(start_time == nil || end_time == nil)
      start_time = Time.now.beginning_of_hour-1.hour
      end_time = start_time + RESOURCE_OFFER_HANDLER_WINDOW_WIDTH
    end
    

    # Add stuff from the schedule relation 
    @resource.offer_schedules.each do |os|
      toAdd = os.generate_working_schedule(start_time, end_time)

      #TODO: replace the += operator with an "interval merge" operator (to be defined)
      @capacity_intervals += toAdd[:capacity_intervals]
      @totalcapacity_interval += toAdd[:capacity_intervals]
      @price_intervals += toAdd[:price_intervals]
      @totalprice_interval += toAdd[:price_intervals]
    end

    # Look through the exception relation and force each change onto the working schedule
    @resource.offer_schedule_exceptions.each do |ose|
      toAdd = ose.generate_working_schedule(start_time, end_time)
      @capacity_intervals = ValuedInterval::force_intervals(toAdd[:capacity_intervals], @capacity_intervals)
      @price_intervals = ValuedInterval::force_intervals(toAdd[:price_intervals], @price_intervals)
      @totalcapacity_interval = ValuedInterval::force_intervals(toAdd[:capacity_intervals], @totalcapacity_interval)
      @totalprice_interval = ValuedInterval::force_intervals(toAdd[:price_intervals], @totalprice_interval)
    end

    # Look through all acceptances and force_interval 
    #TODO: redesign force_interval to allow and "adjustment" of the value 
    #      (as opposed to an "overwriting" of value)
    @resource.acceptances.where("status = ? OR status = ?", "successfully paid", "payment_pending").each do |acc|
      toAdd = acc.generate_working_schedule(start_time, end_time)
      @capacity_intervals = ValuedInterval::force_intervals(toAdd[:capacity_intervals], @capacity_intervals)
    end
  
    #TODO: I need to remember to re-update every so often to advance this window.
  end

  def start_time(time=Time.now(), total=false)
    #toRtn = Time.now
    thisarray = @capacity_intervals
    if(!total)
      thisarray = @totalcapacity_interval
    end
    capIntervals = thisarray.select{|x| x.start_time <= time}.sort{|x,y| y.start_time <=> x.start_time}
    if(capIntervals.size == 0)
      return Time.at(0)
    end
    if(capIntervals.first.capacity < 1)
      return Time.at(0)
    end
    if(capIntervals.first.end_time < time)
      return Time.at(0)
    end

    earliest_cap = capIntervals.first
    earliest_time = earliest_cap.start_time

    capIntervals[1..-1].each do |capIter|
      if(capIter.end_time != earliest_time || capIter.capacity < 1)
        break;
      end

      earliest_cap = capIter
      earliest_time = capIter.start_time
    end

    return earliest_time
  end

  def end_time(time=Time.now(), total=false)
    if(total)
      thisarray = @capacity_intervals
    else
      thisarray = @totalcapacity_interval
    end
    #toRtn = Time.now
    capIntervals = thisarray.select{|x| x.end_time >= time}.sort{|x,y| x.start_time <=> y.start_time}
    if(capIntervals.size == 0)
      return Time.at(0)
    end
    if(capIntervals.first.capacity < 1)
      return Time.at(0)
    end
    if(capIntervals.first.start_time > time)
      return Time.at(0)
    end

    latest_cap = capIntervals.first
    latest_time = latest_cap.end_time

    capIntervals[1..-1].each do |capIter|
      if(capIter.start_time != latest_time || capIter.capacity < 1)
        break;
      end

      latest_cap = capIter
      latest_time = capIter.end_time
    end

    return latest_time
  end

  def dp(type=:c)
    if(type == :c)
      @capacity_intervals.sort{|x,y| x.start_time <=> y.start_time}.each do |c|
        c.dp
      end
    end
    nil
  end

  def validate_reservation(start_time, end_time)
    valid = self.start_time(start_time) <= start_time
    valid = valid && self.end_time(start_time) >= end_time
    return valid
  end

  def validate_reservation_and_find_price(start_time, end_time)
    return validate_reservation(start_time, end_time) ? find_price(start_time, end_time) : -1
  end
      
  def find_price(start_time, end_time)
    toRtn = 0.0
    self.price_intervals.each do |interval|
      effectiveStartTime = [interval.start_time, start_time].max
      effectiveEndTime = [interval.end_time, end_time].min
      if (effectiveEndTime > effectiveStartTime)
        toRtn += (effectiveEndTime - effectiveStartTime).to_f() * interval.price/3600;
      end
    end
    return toRtn
  end

  include PresentationMethods
end


class ValuedInterval
  attr_accessor :start_time
  attr_accessor :end_time

  def initialize(start_time, end_time)
    @start_time = start_time
    @end_time = end_time
  end

  def overlapping?(x)
    return (@end_time - x.start_time) * (x.end_time - @start_time) > 0
  end

  def self.force_intervals(intervals_forcing, intervals_onto_in)
    intervals_onto = intervals_onto_in.dup
    intervals_forcing.each do |vi_forcing|
      #Find and split any overlapping intervals
      toRemove = []
      toAdd = []
      intervals_onto.select{|x| x.overlapping?(vi_forcing)}.each do |vi_onto|
        if vi_onto.start_time < vi_forcing.start_time
          split_left = vi_onto.clone
          split_left.end_time = vi_forcing.start_time
          toAdd << split_left
        end
        if vi_onto.end_time > vi_forcing.end_time
          split_right = vi_onto.clone
          split_right.start_time = vi_forcing.end_time
          toAdd << split_right
        end

        toAdd << vi_forcing
        toRemove << vi_onto
      end
      p "TOADD"
      toAdd.each do |a| a.dp end
      p "TOREMOVE"
      toRemove.each do |a| a.dp end
      intervals_onto += toAdd      
      intervals_onto -= toRemove
      p "INTERVALS_ONTO"
      intervals_onto.each do |a| a.dp end
    end
    return intervals_onto
  end

  def dp
    p [@start_time, @end_time]
  end
end

class PriceInterval < ValuedInterval
  attr_accessor :price

  def initialize(start_time, end_time, price)
    @start_time = start_time
    @end_time = end_time
    @price = price
  end

  def contains(time)
    return time >= @start_time && time <= @end_time
  end
  
  def to_s()
    return "price:#{@price} (from #{@start_time} to #{@end_time})"
  end

  def dp
    p [@start_time, @end_time, @price]
  end

  def as_json(options={})
    {
      :start_time => "#{self.start_time.to_f}",
      :end_time => "#{self.end_time.to_f}",
      :price_per_hour => self.price
    }
  end

  include PresentationMethods
end

class CapacityInterval < ValuedInterval
  attr_accessor :start_time
  attr_accessor :end_time
  attr_accessor :capacity

  def initialize(start_time, end_time, capacity)
    @start_time = start_time
    @end_time = end_time
    @capacity = capacity
  end

  def contains(time)
    return time >= @start_time && time <= @end_time
  end
  
  def to_s()
    return "capacity:#{@capacity} (from #{@start_time} to #{@end_time})"
  end

  def dp
    p [@start_time, @end_time, @capacity]
  end

  def as_json(options={})
    {
      :start_time => "#{self.start_time.to_f}",
      :end_time => "#{self.end_time.to_f}",
      :capacity => self.capacity
    }
  end

  include PresentationMethods
end
