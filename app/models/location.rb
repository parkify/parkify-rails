class Location < ActiveRecord::Base
  attr_accessible :directions, :latitude, :location_address, :location_name, :longitude
  belongs_to :locationable, :polymorphic => true
end
