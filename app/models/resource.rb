class Resource < ActiveRecord::Base
  attr_accessible :capacity, :description, :user_id, :title, :images, :offers, :location, :price_plan
  
  has_many :offers
  has_many :images, :as => :imageable
  has_one :location, :as => :locationable
  has_one :price_plan, :as => :price_planable
  
  has_many :quick_properties
  
  belongs_to :user
  def as_json(options={})
    result = super()
    #result["parking_spot"]["location"] = self.location.as_json
    
    #result["parking_spot"]["
    #result["user"]["name"] = name.capitalize
    result
  end
end
