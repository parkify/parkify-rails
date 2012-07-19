class PricePlan < ActiveRecord::Base
  attr_accessible :price_per_hour
  
  belongs_to :price_planable, :polymorphic => true
  
end
