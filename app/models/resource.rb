class Resource < ActiveRecord::Base
  attr_accessible :capacity, :description, :user_id, :title, :images, :offers, :location, :price_plan, :active
  
  has_many :offers
  has_many :images, :as => :imageable
  has_one :location, :as => :locationable
  has_one :price_plan, :as => :price_planable
  
  has_many :quick_properties
  
  belongs_to :user
  
  def pretty_id
    return "%d" % (100000 + self.id)
  end
  
  def MAX_TIMEFRAME_VIEW_SIZE 
    return 10*3600
  end
  
  def as_json(options={})
    result = super(:only => [:id, :title])
    
    if(options[:id_fix])
      result["id"] = result["id"]+90000
    end
    
    
    
    
    
 
    
    
    
    result["location"] = self.location.as_json(options)
    
    
    #Imagess
    imageIDs = []
    landscape_for_spot_info_page_ids = []
    landscape_for_spot_conf_page_ids = []
    standard_for_instructions_ids = []
    self.images.each do |i|
      imageIDs << i.id
      if i.landscape_for_spot_info_page
        landscape_for_spot_info_page_ids << i.id
      end
      if i.landscape_for_spot_conf_page
        landscape_for_spot_conf_page_ids << i.id
      end
      if i.standard_for_instructions
        standard_for_instructions_ids << i.id
      end
    end
   
    result["imageIDs"] = imageIDs.as_json
    result["land_info"] = landscape_for_spot_info_page_ids.as_json
    result["land_conf"] = landscape_for_spot_conf_page_ids.as_json
    result["standard"] = standard_for_instructions_ids.as_json
    
    
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
    
    if(open_consecutive_offers == [] || !(self.active == true))
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
