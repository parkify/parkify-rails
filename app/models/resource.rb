class Resource < ActiveRecord::Base
  attr_accessible :capacity, :description, :user_id, :title, :images, :offers, :location, :price_plan
  
  has_many :offers
  has_many :images, :as => :imageable
  has_one :location, :as => :locationable
  has_one :price_plan, :as => :price_planable
  
  has_many :quick_properties
  
  belongs_to :user
  def as_json(options={})
    result = super()
    
    result["location"] = self.location.as_json
    
    activeInterval = CapacityInterval.new({:capacity => 1, :start_time => Time.now, :end_time => Time.now + (1.5*3600)})
    #so im a resource, i know what offers I am yielding, and they have a capacitylist that knows if its overlapping currenttime.
    active_offer = nil
    self.offers.each do |offer|
      if(offer.capacity_list.can_add?(activeInterval))
        active_offer = offer
        break
      end
    end
    
    if(active_offer == nil)
      result["free"] = "false"
      result["end_time"] = ""
      result["price_plan"] = ""
      result["offer_id"] = ""
    else
      result["free"] = "true"
      result["end_time"] = "#{active_offer.end_time.to_f}"
      result["price_plan"] = active_offer.price_plan.as_json
      result["offer_id"] = "#{active_offer.id}"
    end
      
    result["quick_properties"] = {}
    self.quick_properties.each do |p|
      if(p.key == nil) or (p.value == nil)
        continue
      end
      key = p.key.to_s
      value = p.value.to_s
      result["quick_properties"][key] = value
    end
    
    
    
    result
  end
end
