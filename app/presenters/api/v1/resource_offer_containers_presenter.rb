class Api::V1::ResourceOfferContainersPresenter < Api::V1::ApplicationPresenter
  
  def as_json(roc, options={})
    # Check Availability
    p "Api::V1::ResourceOfferContainersPresenter::as_json"
    start_time = roc.start_time(Time.now(), true)
    end_time = roc.end_time(Time.now(), true)
    available = ( roc.resource.active && (end_time - start_time) >= 2.hours )
    result = {
      :id => roc.resource.id + 90000, # id fix for this version
      :title => roc.resource.title,
      :free => available.to_s,
      :available => available,
      :quick_properties => self.quick_properties_as_json(roc),
      :location => {
        :latitude => roc.resource.latitude,
        :longitude => roc.resource.longitude,
        :location_name => roc.resource.location_name
      }
    }
    
    if(options[:level_of_detail] == "all")
      #Images
      imageIDs = []
      landscape_for_spot_info_page_ids = []
      landscape_for_spot_conf_page_ids = []
      standard_for_instructions_ids = {}
      roc.images.each do |i|
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
     
      result.deep_merge!( {
        :description => roc.resource.description,
        :location => {
          :directions => roc.resource.xml_directions,
          :location_address => roc.resource.location_address
        },
        :imageIDs => imageIDs.as_json,
        :land_info => landscape_for_spot_info_page_ids.as_json,
        :land_conf => landscape_for_spot_conf_page_ids.as_json,
        :standard => standard_for_instructions_ids.as_json,
        :offers => [self.offer_as_json(roc, start_time, end_time)]
      } )
    end

    return result
  end

  def offer_as_json(roc, start_time, end_time)
    {
      :id => roc.resource.id,
      :start_time => "#{start_time.to_f}",
      :end_time => "#{end_time.to_f}",
      :price_plan => {
        :price_list => roc.price_intervals.map{|e| self.price_interval_as_json(e)}
      }
    }
  end

  def quick_properties_as_json(roc)
    result = {}
    roc.quick_properties.each do |p|
      if(p.key == nil) or (p.value == nil)
        continue
      end
      key = p.key.to_s
      value = p.value.to_s
      result[key] = value
    end
    result
  end

  def price_interval_as_json(p)
    {
      :start_time => "#{p.start_time.to_f}",
      :end_time => "#{p.end_time.to_f}",
      :price_per_hour => p.price
    }
  end

  
  
end
