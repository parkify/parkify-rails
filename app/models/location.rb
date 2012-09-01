class Location < ActiveRecord::Base
  attr_accessible :directions, :latitude, :location_address, :location_name, :longitude
  belongs_to :locationable, :polymorphic => true
  
  def as_json(options={})
    result = super(:only => [:latitude, :longitude, :location_name])
    
    if(options[:level_of_detail] == "all")
      result["directions"] = self.directions
      result["location_address"] = self.location_address
    end
    
    result
  end
end
