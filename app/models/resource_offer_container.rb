class ResourceOfferContainer < Ohm::Model
  attr_accessor :resource
  attr_accessor :price_intervals
  attr_accessor :capacity_intervals
  attr_accessor :capacity_interval_without_acceptances
  attr_accessor :updated_from_sql

  attribute :ohm_ization
  attribute :resource_offer_id
  unique :resource_offer_id

#OK, so we need: thaw (essentially update_from_redis), save (updating the redis serialization), update_from_sql (to do reservations, and to update availability, etc). 

  def self.update_all_spots()
    #ResourceOfferContainer.all.each do |roc|
    #  roc.delete
    #end
    ResourceOffer.pluck(:id).each do |ro|
      ResourceOfferContainer::update_spot(ro)
    end
  end

  def self.update_spot(resource_offer_id, create_if_not_exists=true)
    p "*** ^S#{resource_offer_id} ***"
    if(create_if_not_exists)
      toUpdate = ResourceOfferContainer.find_or_create(resource_offer_id)
    else
      toUpdate =  ResourceOfferContainer.with(:resource_offer_id, resource_offer_id)
    end

    if(!toUpdate)
      return
    end

    if(!toUpdate.updated_from_sql)
      toUpdate.update_from_sql
    end

    toUpdate.save!
  end

  def save!
    self.ohm_ization = ActiveSupport::JSON.encode({
      :resource => self.resource,
      :price_intervals => self.price_intervals,
      :capacity_intervals => self.capacity_intervals,
      :capacity_intervals_without_acceptances => self.capacity_intervals_without_acceptances
    })
    super
  end

  def self.find_or_create(resource_offer_id)
    toRtn = ResourceOfferContainer.with(:resource_offer_id, resource_offer_id)
    if(!toRtn)
      toRtn = ResourceOfferContainer.create ({:resource_offer_id => resource_offer_id})
      toRtn.update_from_sql
      toRtn.save!
      toRtn.updated_from_sql = true
    else
      toRtn.thaw
      toRtn.updated_from_sql = false
    end
    return toRtn
  end



  #def initialize(resource=nil, options={})
  #  @resource = resource
  #  @price_intervals = []
  #  @capacity_intervals = []
  #  @capacity_intervals_without_acceptances=[]
  #  update_availability(options[:start_time], options[:end_time], options[:no_update_info]) unless options[:no_update]
  #  self
  #end

  

  def update_info
    if !@resource
      @resource = ResourceOffer.find(self.resource_offer_id)
    else
      @resource.reload
    end
  end

  # update both price and capacity intervals
  def update_from_sql(start_time=nil, end_time=nil)
    update_info 
    
    @capacity_intervals = []
    @price_intervals = []
    @capacity_intervals_without_acceptances= []

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
      @capacity_intervals_without_acceptances += toAdd[:capacity_intervals]
      @price_intervals += toAdd[:price_intervals]
    end

    # Look through the exception relation and force each change onto the working schedule
    @resource.offer_schedule_exceptions.each do |ose|
      toAdd = ose.generate_working_schedule(start_time, end_time)
      @capacity_intervals = ValuedInterval::force_intervals(toAdd[:capacity_intervals], @capacity_intervals)
      @price_intervals = ValuedInterval::force_intervals(toAdd[:price_intervals], @price_intervals)
      @capacity_intervals_without_acceptances = ValuedInterval::force_intervals(toAdd[:capacity_intervals], @capacity_intervals_without_acceptances)
    end

    # Look through all acceptances and force_interval 
    #TODO: redesign force_interval to allow and "adjustment" of the value 
    #      (as opposed to an "overwriting" of value)
    @resource.acceptances.where("status = ? OR status = ?", "successfully paid", "payment_pending").each do |acc|
      toAdd = acc.generate_working_schedule(start_time, end_time)
      @capacity_intervals = ValuedInterval::force_intervals(toAdd[:capacity_intervals], @capacity_intervals)
    end
    #TODO: I need to remember to re-update every so often to advance this window.
    self.updated_from_sql = true

    return self
  end
  
  def start_time(time=Time.now(), wo_acceptances=true)
    #toRtn = Time.now
    thisarray = @capacity_intervals
    if(wo_acceptances)
      thisarray = @capacity_intervals_without_acceptances
    end
    capIntervals = thisarray.select{|x| x.start_time <= time}.sort{|x,y| y.start_time <=> x.start_time}
    if(capIntervals.size == 0)
      #p ["no cap Intervals in ResourceOfferContainer::start_time", time, total, thisarray, self]
      return Time.at(1)
    end
    if(capIntervals.first.capacity < 1)
      return Time.at(2)
    end
    if(capIntervals.first.end_time < time)
      return Time.at(3)
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

  def end_time(time=Time.now(), wo_acceptances=true)
    thisarray = @capacity_intervals
    if(wo_acceptances)
      thisarray = @capacity_intervals_without_acceptances
    end
    #toRtn = Time.now
    capIntervals = thisarray.select{|x| x.end_time >= time}.sort{|x,y| x.start_time <=> y.start_time}
    
    #find a starting point
    i = 0
    capIntervals[0..-1].each do |capIter|
      if (capIter.start_time <= time) and (capIter.end_time >= time) and (capIter.capacity >= 1)
        break;
      end
      i += 1
    end

    if (i == capIntervals.count)
      return Time.at(0)
    end

    latest_cap = capIntervals[i]
    latest_time = latest_cap.end_time
    if (i+1 < capIntervals.count)
      capIntervals[i+1..-1].each do |capIter|
        if(capIter.start_time != latest_time || capIter.capacity < 1)
          break;
        end

        latest_cap = capIter
        latest_time = capIter.end_time
      end
    end

    return latest_time
  end


  def validate_reservation(acceptance)
    if(!acceptance)
      return false
    end
    valid = self.start_time(acceptance.start_time, false) <= acceptance.start_time
    valid = valid && (self.end_time(acceptance.start_time, false) >= acceptance.end_time)
    return valid
  end

  def validate_reservation_and_find_price(acceptance)
    return validate_reservation(acceptance) ? find_price(acceptance) : -1
  end
      
  def find_price(acceptance)
    toRtn = -1
    if(!acceptance)
      return -1
    end
    if (acceptance.price_type == "hourly")
      toRtn = 0.0
      self.price_intervals.each do |interval|
        effectiveStartTime = [interval.start_time, acceptance.start_time].max
        effectiveEndTime = [interval.end_time, acceptance.end_time].min
        if (effectiveEndTime > effectiveStartTime)
          toRtn += (effectiveEndTime - effectiveStartTime).to_f() * interval.price/3600
        end
      end
    elsif (acceptance.price_type == "flat_rate")
      self.price_intervals.each do |interval|
        if (interval.start_time <= acceptance.start_time &&
          interval.end_time >= acceptance.start_time)
          flat_price = interval.flat_rate_prices[price_name]
          if(flat_price)
            toRtn = flat_price[:price]
          end
        end
      end
    end

    return toRtn
  end

  def thaw
    thawed_hash = ActiveRecord::JSON.decode(self.ohm_ization)
    if(!thawed_hash)
      return #TODO: throw exception
    end

    self.resource = ResourceOffer.new(thawed_hash["resource"])
    self.resource.id = thawed_hash["resource"]["id"]
    
    self.price_intervals = []
    if thawed_hash["price_intervals"]
      toRtn.price_intervals = thawed_hash["price_intervals"].map{|interval| PriceInterval.from_hash(interval)}
    end

    self.capacity_intervals = []
    if thawed_hash["capacity_intervals"]
      toRtn.capacity_intervals = thawed_hash["capacity_intervals"].map{|interval| CapacityInterval.from_hash(interval)}
    end


    self.capacity_intervals_without_acceptances = []
    if thawed_hash["capacity_intervals_without_acceptances"]
      toRtn.capacity_intervals_without_acceptances = thawed_hash["capacity_intervals_without_acceptances"].map{|interval| CapacityInterval.from_hash(interval)}
    end

    return self
  end

  #include PresentationMethods
end
