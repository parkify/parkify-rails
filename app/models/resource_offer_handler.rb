RESOURCE_OFFER_HANDLER_WINDOW_WIDTH = 2.days

# Not an ActiveRecord model. Builds and updates an in-memory schedule for spots.
# Updates from a json serialization in redis to maintain state across multiple
# rails processes.
class ResourceOfferHandler < Ohm::Model
  

  #def update_resource_info(resource_offers)
  #  resource_offers.each do |ro|
  #    if !@resources[ro]
  #      @resources[ro] = ResourceOfferContainer.new(ResourceOffer.find_by_id(ro))
  #    else
  #      @resources[ro].update_info()
  #    end
  #  end
  #  self.save!
  #end


  #def update_resource_availability(resource_offers)
  #  resource_offers.each do |ro|
  #    if !@resources[ro]
  #      @resources[ro] = ResourceOfferContainer.new(ResourceOffer.find_by_id(ro))
  #    else
  #      @resources[ro].update_availability()
  #    end
  #  end
  #  self.save!
  #end

  #def update_from_redis()
  #  
  #  from_redis = ResourceOfferHandler.find(:is_singleton => "true").first
  #  if from_redis && self.updated_at < from_redis.updated_at
  #
  #    
  #    self.load!
  #    self.resources = {}
  #    ActiveSupport::JSON.decode(self.resources_ohm).each do |k,v|
  #      
  #      self.resources[k.to_i] = ResourceOfferContainer.from_hash(v) 
  #    end
  #    
  #    
  #    self.activeresources = {}
  #    ActiveSupport::JSON.decode(self.activeresources_ohm).each do |k,v|
  #      
  #      self.activeresources[k.to_i] = ResourceOfferContainer.from_hash(v) if v and !v.empty?
  #    end
  #    
  #  end
  #end
  
  def retrieve_spots(options={})
    if options[:active]
      toRtn = Hash[*(ResourceOfferContainer.all.map{|x| x.thaw}.map{|x| [x.resource_offer_id, x]}.flatten)]
      return toRtn.reject{|k,v| !v.resource.active}
    elsif options[:only]
      return options[:only].map{|x| ResourceOfferContainer.find_or_create(x)}
    else
      p ["EXPECTED DIFFERENT OPTIONS", options]
      return []
    end
  end


  def self.validate_reservation_and_find_price(resource_offer_id, acceptance, use_cache=true)
    fresh_container = ResourceOfferContainer.find_or_create(resource_offer_id)
    if(fresh_container == nil)
      return -1
    end
    if(!fresh_container.updated_from_sql && !use_cache)
      #fresh_container.update_from_sql(acceptance.start_time, acceptance.end_time)
      fresh_container.update_from_sql()
    end
    return fresh_container.validate_reservation_and_find_price(acceptance)
  end 

  def self.validate_reservation_from_sql(resource_offer_id, acceptance, use_cache=true)
    fresh_container = ResourceOfferContainer.find_or_create(resource_offer_id)
    if(fresh_container == nil)
      return -1
    end
    if(!fresh_container.updated_from_sql && !use_cache)
      #fresh_container.update_from_sql(acceptance.start_time, acceptance.end_time)
      fresh_container.update_from_sql()
    end
    return fresh_container.validate_reservation(acceptance)
  end

end


