class CapacityInterval < ActiveRecord::Base
  attr_accessible :capacity, :capacity_list_id, :end_time, :start_time
  
  belongs_to :capacity_list
  
  def contains(time)
    return time >= start_time && time <= end_time
  end
  
  # not (|--interval--| |--self--| or |--self--| |--interval--|)
  def overlaps_with_interval(interval)
    return not(interval.start_time >= end_time or interval.end_time <= start_time)
  end
  
end
