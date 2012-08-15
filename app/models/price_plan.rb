class PricePlan < ActiveRecord::Base
  attr_accessible :price_per_hour
  has_many :price_intervals
  
  belongs_to :price_planable, :polymorphic => true
  
  def as_json(options={})
    result = super()
    
    result["price_list"] = self.price_intervals.as_json
    result
  end
end
