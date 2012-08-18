class PriceInterval < ActiveRecord::Base
  attr_accessible :end_time, :price_per_hour, :price_plan_id, :start_time
  belongs_to :price_plan
  
  def as_json(options={})
    results = super()
    results[:start_time] = "#{self.start_time.to_f}"
    results[:end_time] = "#{self.end_time.to_f}"
    result
  end
end
