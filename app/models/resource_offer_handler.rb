RESOURCE_OFFER_HANDLER_WINDOW_WIDTH = 1.week

# Not an ActiveRecord model. Builds and updates an in-memory schedule for spots.
# Updates from a json serialization in redis to maintain state across multiple
# rails processes.
class ResourceOfferHandler < Ohm::Model
  attribute :resources_ohm
  attribute :activeresources_ohm
  attribute :updated_at_ohm
  attribute :is_singleton
  index :is_singleton

  def resources=(r)
    @resources=r
  end
  def resources
    @resources
  end
  def activeresources=(r)
    @activeresources=r
  end
  def activeresources
    @activeresources
  end
  

  def updated_at=(t)
    self.updated_at_ohm = t.to_f
  end

  def updated_at
    Time.at(self.updated_at_ohm.to_f)
  end

  def save!
    self.resources_ohm = ActiveSupport::JSON.encode(self.resources)
    self.activeresources_ohm = ActiveSupport::JSON.encode(self.activeresources)
    self.updated_at = Time.now
    debug_check_2("after save ")
    debug_check_3
    super
  end
  
  def self.make_singleton
    theSingleton = ResourceOfferHandler.new
    fromRedis = ResourceOfferHandler.find(:is_singleton => "true")
    if fromRedis.first
      theSingleton = fromRedis.first
    else
      theSingleton.is_singleton = "true"
    end
    theSingleton.resources = {}
    theSingleton.activeresources = {}
    ResourceOffer.all.each do |ro|
      theSingleton.resources[ro.id] = ResourceOfferContainer.new(ro)
      if (ro.active)
        theSingleton.activeresources[ro.id] = theSingleton.resources[ro.id]
      end
    end
    theSingleton.save!

    theSingleton
  end

  def update_resource_info(resource_offers)
    resource_offers.each do |ro|
      if !@resources[ro]
        @resources[ro] = ResourceOfferContainer.new(ResourceOffer.find_by_id(ro))
      else
        @resources[ro].update_info()
      end
    end
    
    self.save!
  end

  def update_resource_availability(resource_offers)
    resource_offers.each do |ro|
      if !@resources[ro]
        @resources[ro] = ResourceOfferContainer.new(ResourceOffer.find_by_id(ro))
      else
        @resources[ro].update_availability()
      end
    end

    self.save!
  end

  def update_from_redis()
    from_redis = ResourceOfferHandler.find(:is_singleton => "true").first
    if from_redis && self.updated_at < from_redis.updated_at
      self.load!
      self.resources = {}
      printdebug = false
      ActiveSupport::JSON.decode(self.resources_ohm).each do |k,v|
        if v and !v.empty?
          self.resources[k.to_i] = ResourceOfferContainer.from_hash(v) 
        else
          p ["trying to assign empty resource:", k]
          printdebug = true
        end
      end

      if printdebug
        p self.resources_ohm
        p ActiveSupport::JSON.decode(self.resources_ohm)
      end
 
      self.activeresources = {}
      ActiveSupport::JSON.decode(self.activeresources_ohm).each {|k,v| self.activeresources[k.to_i] = ResourceOfferContainer.from_hash(v) if v and !v.empty?}
    end
    debug_check_2("after update_from_redis")
  end
  
  def retrieve_spots(options={})
    update_from_redis

    self.debug_check_1
    
    if options[:all]
      return @resources.values
    elsif options[:active]
      return @activeresources
    elsif options[:only]
      return options[:only].map{|x| @resources[x]}
    else
      return []
    end
  end

  def validate_reservation(resource_offer_id, start_time, end_time)
    update_from_redis

    resource_offer_container = @resources[resource_offer_id]
    if(resource_offer_container == nil)
      return false
    else
      return resource_offer_container.validate_reservation(start_time, end_time)
    end
  end

  def validate_reservation_and_find_price(resource_offer_id, start_time, end_time)
    update_from_redis

    resource_offer_container = @activeresources[resource_offer_id]
    if(resource_offer_container == nil)
      p ["Resource_offer_container was nil for id  ", resource_offer_id]
      return -1
    else
      return resource_offer_container.validate_reservation_and_find_price(start_time, end_time)
    end
  end

  def self.validate_reservation_and_find_price(resource_offer_id, start_time, end_time)
    fresh_container = ResourceOfferContainer.new(ResourceOffer.find_by_id(resource_offer_id), {:start_time=>start_time, :end_time=>end_time, :no_update_info=>true})
    return fresh_container.validate_reservation_and_find_price(start_time, end_time)
  end

  def self.validate_reservation(resource_offer_id, start_time, end_time)
    fresh_container = ResourceOfferContainer.new(ResourceOffer.find_by_id(resource_offer_id), {:start_time=>start_time, :end_time=>end_time, :no_update_info=>true})
    return fresh_container.validate_reservation(start_time, end_time)
  end

  def debug_check_1
    self.resources do |k,v|
      if(v.resource.id == nil)
        p ["Empty resource offer container:", k, v]
      end
    end
    self.activeresources do |k,v|
      if(v.resource.id == nil)
        p ["Empty active resource offer container:", k, v]
      end
    end
  end

  def debug_check_3
    self.resources do |k,v|
      if(v.resource.id == nil)
        p ["Empty resource offer container: dc3"]
        break
      end
    end
    self.activeresources do |k,v|
      if(v.resource.id == nil)
        p ["Empty active resource offer container: dc3"]
        break
      end
    end
  end

  def debug_check_2(s)

    if self.resources_ohm.include?("resource_offer")
      p ["malformed hash created in ", s]
    end
    
    if self.activeresources_ohm.include?("resource_offer")
      p ["malformed hash created in ", s]
    end

  end

end


