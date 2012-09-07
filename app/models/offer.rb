class Offer < ActiveRecord::Base
  attr_accessible :capacity, :end_time, :start_time, :resource_id, :location, :capacity_list, :price_plan

  belongs_to :resource
  
  has_many :agreements
  has_many :acceptances, :through => :agreements
  has_one :price_plan, :as => :price_planable
  has_one :location, :as => :locationable
  has_one :capacity_list
  
  def find_cost(eff_start_time, eff_end_time)
    return self.price_plan.find_cost(eff_start_time, eff_end_time)
  end
  
  def is_current
    return (self.start_time <= Time.now) && (Time.now <= self.end_time)
  end
  
  def location
    if(read_attribute(:location))
      return read_attribute(:location)
    else
      if(read_attribute(:resource))
        return read_attribute(:resource).location
      else
        return nil
      end
    end
  end
  
  def updateWithParent!
  
    puts "----------------------------------------------------WORK WORK WORK WORK ;("
    
    self.capacity = resource.capacity
    
    #location = resource.location.dup
    #location.locationable = self
    self.location = location
    
    
    price_plan = resource.price_plan.dup
    price_plan.price_planable = self
    self.price_plan = price_plan
    
    
    self.price_plan.generate_price_interval(start_time, end_time)
    
      #TODO: move this logic into constructor for capacity_list
    self.capacity_list = CapacityList.create()
    self.capacity_list.capacity_intervals.create({:start_time => start_time, :end_time => end_time, :capacity => capacity})
    
    
    
    self.save!
  end
  
  
  def as_json(options={})
    result = super()
    
    result[:start_time] = "#{self.start_time.to_f}"
    result[:end_time] = "#{self.end_time.to_f}"
    
    result["price_plan"] = price_plan.as_json
    
    result
  end
  
  
  #def updateWithParent!
  #  if capacity == nil
  #    capacity = resource.capacity
  #  end
  #  if location == nil
  #    location = resource.location
  #  end
  #  if price_plan == nil
  #    price_plan = resource.price_plan
  #  end
  #  if capacity_list == nil
  #    #TODO: move this logic into constructor for capacity_list
  #    capacity_list = CapacityList.create()
  #    capacity_list.capacity_intervals.create({:start_time => start_time, :end_time => end_time, :capacity => capacity})
  #  end
  #  if capacity_list.capacity_intervals = []
  #    capacity_list.capacity_intervals.create({:start_time => start_time, :end_time => end_time, :capacity => capacity})
  #  end
  #  
  #  save!
  #end
end
