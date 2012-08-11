class Offer < ActiveRecord::Base
  attr_accessible :capacity, :end_time, :start_time, :resource_id, :location, :capacity_list, :price_plan

  belongs_to :resource
  
  has_many :acceptances
  has_one :price_plan, :as => :price_planable
  has_one :location, :as => :locationable
  has_one :capacity_list
  
  def updateWithParent!
    capacity = resource.capacity
    
    
    location = resource.location
    
    
    price_plan = resource.price_plan
    
    
      #TODO: move this logic into constructor for capacity_list
    capacity_list = CapacityList.create()
    capacity_list.capacity_intervals.create({:start_time => start_time, :end_time => end_time, :capacity => capacity})
    
    
    capacity_list.capacity_intervals.create({:start_time => start_time, :end_time => end_time, :capacity => capacity})
    
    
    save!
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
