class Api::V1::ParkingSpotsPresentr
  
  def resource_offer_as_json(resource_offer, options={})
    result = resource_offer.as_json(:only=> [:id, :title])

    if(options[:id_fix])
      result["id"] = result["id"]+90000
    end


    if(options[:as_offer]) 
      result = super(:only => [:id])
      result[:start_time] = "#{self.start_time.to_f}"
      result[:end_time] = "#{self.end_time.to_f}"
      result["price_plan"] = self.as_json({:as_price_plan=>true})
    
      return result
    end

    if(options[:as_price_plan])
      result = super()
      current = nil
      self.price_intervals.each do |pr|
        if(pr.start_time <= Time.now and pr.end_time >= Time.now)
          current = pr
          break
        end
      end
      if current
        intervals = [current] + (self.price_intervals - [current])
        result["price_list"] = intervals.as_json
      else
        result["price_list"] = self.price_intervals.as_json
      end
      
      return result
    end 

    result = super(:only => [:id, :title])
    
    if(options[:id_fix])
      result["id"] = result["id"]+90000
    end
    
    result["location"] = self.location.as_json(options)
    
    #Images
    imageIDs = []
    landscape_for_spot_info_page_ids = []
    landscape_for_spot_conf_page_ids = []
    standard_for_instructions_ids = {}
    self.images.each do |i|
      imageIDs << i.id
      if i.landscape_for_spot_info_page
        landscape_for_spot_info_page_ids << i.id
      end
      if i.landscape_for_spot_conf_page
        landscape_for_spot_conf_page_ids << i.id
      end
      if i.standard_for_instructions
        standard_for_instructions_ids[i.name] = i.id
      end
    end
   
    result["imageIDs"] = imageIDs.as_json
    result["land_info"] = landscape_for_spot_info_page_ids.as_json
    result["land_conf"] = landscape_for_spot_conf_page_ids.as_json
    result["standard"] = standard_for_instructions_ids.as_json
    
    activeInterval = CapacityInterval.new({:capacity => 1, :start_time => Time.now, :end_time => Time.now + (1.5*3600)})
    logger("api_formatter"); 
    if(!can_add?(activeInterval) || !(self.active == true))
      result["free"] = "false"
      if(options[:level_of_detail] == "all")
        result["offers"] = ""
      end
    else
      result["free"] = "true"
      if(options[:level_of_detail] == "all")
        result["offers"] = [self].as_json({:as_offer=>true})
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
