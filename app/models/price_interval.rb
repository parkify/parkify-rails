class PriceInterval < ActiveRecord::Base
  attr_accessible :end_time, :price_per_hour, :price_plan_id, :start_time
end
