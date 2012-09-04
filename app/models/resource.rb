class Resource < ActiveRecord::Base
  attr_accessible :capacity, :description, :user_id, :title, :images, :offers, :location, :price_plan
  
  has_many :offers
  has_many :images, :as => :imageable
  has_one :location, :as => :locationable
  has_one :price_plan, :as => :price_planable
  
  has_many :quick_properties
  
  belongs_to :user
  
  def MAX_TIMEFRAME_VIEW_SIZE 
    return 10*3600
  end
  
  def as_json(options={})
    result = super(:only => [:id, :title])
    
    result["location"] = self.location.as_json(options)
    
    imageIDs = []
    p self.images
    self.images.each do |i|
      imageIDs << i.id
    end
    result["imageIDs"] = imageIDs.as_json
    
    activeInterval = CapacityInterval.new({:capacity => 1, :start_time => Time.now, :end_time => Time.now + (1.5*3600)})
    #so im a resource, i know what offers I am yielding, and they have a capacitylist that knows if its overlapping currenttime.
    open_consecutive_offers = []
    self.offers.order('start_time').each do |offer|
      if(open_consecutive_offers == [])
        if(offer.capacity_list.can_add?(activeInterval))
          open_consecutive_offers << offer
        end
      else
        if (offer.start_time == open_consecutive_offers.last.end_time)
          open_consecutive_offers << offer
            if (offer.end_time - Time.now) >= self.MAX_TIMEFRAME_VIEW_SIZE
              break
            end
        else
          break
        end
      end
    end
    
    if(open_consecutive_offers == [])
      result["free"] = "false"
      if(options[:level_of_detail] == "all")
        result["offers"] = ""
      end
    else
      result["free"] = "true"
      if(options[:level_of_detail] == "all")
        result["offers"] = open_consecutive_offers.as_json
      end
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
    
    if(options[:level_of_detail] == "all")
      result["description"] = self.description
    end
    result
  end
end
