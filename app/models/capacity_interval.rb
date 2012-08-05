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
  scope :overlapping, lambda { |interval| {
    :conditions => ["( start_time < ? AND ? < end_time ) OR  ( start_time < ? AND ? < end_time )", interval.start_time, interval.start_time, interval.end_time, interval.end_time]
  }}
end
 