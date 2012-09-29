class PricePlan < ActiveRecord::Base
  attr_accessible :price_per_hour
  has_many :price_intervals
  
  belongs_to :price_planable, :polymorphic => true
  
  def generate_price_interval(start_time, end_time)
    self.price_intervals.create({:end_time=>end_time, :price_per_hour=>self.price_per_hour, :start_time=>start_time})
  end
  
  def find_cost(start_time, end_time)
    toRtn = 0.0
    
    self.price_intervals.each do |interval|
      effectiveStartTime = [interval.start_time, start_time].max
      effectiveEndTime = [interval.end_time, end_time].min
      if (effectiveEndTime > effectiveStartTime)
        toRtn += (effectiveEndTime - effectiveStartTime).to_f() * interval.price_per_hour/3600;
      end
    end
    return toRtn
  end
  
  def as_json(options={})
    result = super()
    
    current = nil
    self.price_intervals.each do |pr|
      if(pr.start_time <= Time.now and pr.end_time >= Time.now)
        current = pr
        break
      end
    end
    
    if current
      intervals = [current] + (self.price_intervals - [current])
      result["price_list"] = intervals.as_json
    else
      result["price_list"] = self.price_intervals.as_json
    end
    
    result
  end
end
