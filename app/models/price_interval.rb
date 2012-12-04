class PriceIntervalOld < ActiveRecord::Base
  attr_accessible :end_time, :price_per_hour, :resource_offer_id, :start_time
  belongs_to :resource_offer
  
  def as_json(options={})
    result = super()
    result[:start_time] = "#{self.start_time.to_f}"
    result[:end_time] = "#{self.end_time.to_f}"
    result
  end
end
