class ResourceOfferContainer 
  attr_accessor :resource
  attr_accessor :price_intervals
  attr_accessor :capacity_intervals
  attr_accessor :totalprice_interval
  attr_accessor :totalcapacity_interval

  def initialize(resource=nil, options={})
    @resource = resource
    @price_intervals = []
    @capacity_intervals = []
    @totalprice_interval =[]
    @totalcapacity_interval=[]
    update_availability(options[:start_time], options[:end_time], options[:no_update_info]) unless options[:no_update]
    self
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
  
  def debug_temp(x,y)
    if(!x)
      p self
    end
    x.start_time <= y
  end

  def start_time(time=Time.now(), total=false)
    #toRtn = Time.now
    thisarray = @capacity_intervals
    if(!total)
      thisarray = @totalcapacity_interval
    end
    capIntervals = thisarray.select{|x| self.debug_temp(x,time)}.sort{|x,y| y.start_time <=> x.start_time}
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
        toRtn += (effectiveEndTime - effectiveStartTime).to_f() * interval.price/3600
      end
    end
    return toRtn
  end

  def self.from_hash(h)
    if(! h["resource"])
      p h
    end
    resource = ResourceOffer.new(h["resource"])

    resource.id = h["resource"]["id"]
    
    if (resource.id == nil)
      puts ["bad hash in ResourceOfferContainer::from_hash", h]
    end

    toRtn = ResourceOfferContainer.new(resource, {:no_update => true})
    
    toRtn.price_intervals = []
    if h["price_intervals"]
      toRtn.price_intervals = h["price_intervals"].map{|interval| PriceInterval.from_hash(interval)}
    end

    toRtn.capacity_intervals = []
    if h["capacity_intervals"]
      toRtn.capacity_intervals = h["capacity_intervals"].map{|interval| CapacityInterval.from_hash(interval)}
    end

    toRtn.totalprice_interval = []
    if h["totalprice_interval"]
      toRtn.totalprice_interval = h["totalprice_interval"].map{|interval| PriceInterval.from_hash(interval)}
    end

    toRtn.capacity_intervals = []
    if h["totalcapacity_interval"]
      toRtn.capacity_intervals = h["totalcapacity_interval"].map{|interval| CapacityInterval.from_hash(interval)}
    end

    

    return toRtn
  end

  #include PresentationMethods
end
