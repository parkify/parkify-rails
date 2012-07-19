class Resource < ActiveRecord::Base
  attr_accessible :capacity, :description, :vendor_id
  
  has_many :offers
  has_many :images, :as => :imageable
  has_one :location, :as => :locationable
  has_one :price_plan, :as => :price_planable
  
  belongs_to :user, :foreign_key => :vendor_id
  
end
