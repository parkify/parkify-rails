class CapacityInterval < ActiveRecord::Base
  attr_accessible :capacity, :capacity_list_id, :end_time, :start_time
  
  belongs_to :capacity_list
  
  def contains(time)
    return time >= start_time && time <= end_time
  end

  # Check if a given interval overlaps this interval    
  def overlaps?(other)
    (start_date - other.end_date) * (other.start_date - end_date) >= 0
  end

  # Return a scope for all interval overlapping the given interval, including the given interval itself
  named_scope :overlapping, lambda { |interval| {
    :conditions => ["(TIMEDIFF(start_time, ?) * TIMEDIFF(?, end_time)) > 0", interval.end_time, interval.start_time]
  }}
end
