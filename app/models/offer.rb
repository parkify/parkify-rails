class Offer < ActiveRecord::Base
  attr_accessible :capacity, :end_time, :start_time, :resource_id

  belongs_to :resource
  
  has_many :acceptances
  has_one :price_plan, :as => :price_planable
  has_one :location, :as => :locationable
  has_one :capacity_list
  
  
end
