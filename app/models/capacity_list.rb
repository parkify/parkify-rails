class CapacityList < ActiveRecord::Base
  attr_accessible :offer_id
  
  has_many :capacity_intervals
  
  belongs_to :offer
  
end
