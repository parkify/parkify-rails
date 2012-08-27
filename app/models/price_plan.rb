class PricePlan < ActiveRecord::Base
  attr_accessible :price_per_hour
  has_many :price_intervals
  
  belongs_to :price_planable, :polymorphic => true
  
  def generate_price_interval(start_time, end_time)
    self.price_intervals.create({:end_time=>end_time, :price_per_hour=>self.price_per_hour, :start_time=>start_time)
  end
  
  def as_json(options={})
    result = super()
    
    result["price_list"] = self.price_intervals.as_json
    result
  end
end
