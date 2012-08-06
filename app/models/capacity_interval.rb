class CapacityInterval < ActiveRecord::Base
  attr_accessible :capacity, :capacity_list_id, :end_time, :start_time
  
  belongs_to :capacity_list
  
  def contains(time)
    return time >= start_time && time <= end_time
  end

  # Check if a given interval overlaps this interval    
  #def overlaps?(other)
  #  (start_time - other.end_time) * (other.start_time - end_time) >= 0
  #end

  # Return a scope for all interval overlapping the given interval, including the given interval itself
  #scope :overlapping, lambda { |interval| {
  #  #:conditions => ["(DATEDIFF(start_time, ?) * DATEDIFF(?, end_date)) >= 0", interval.end_date, interval.start_date]
  #  :conditions => ["((start_time, end_time)OVERLAPS(?,?) AND NOT(start_time >= ? OR end_time <= ?))", interval.start_time, interval.end_time, interval.end_time, interval.start_time]
  #}}
  
  scope :overlapping, lambda { |interval|
  where(["((CAST(start_time AS TIMESTAMP), CAST(end_time AS TIMESTAMP))OVERLAPS(CAST(? AS TIMESTAMP),CAST(? AS TIMESTAMP)) AND NOT(CAST(start_time AS TIMESTAMP) >= CAST(? AS TIMESTAMP) OR CAST(end_time AS TIMESTAMP) <= CAST(? AS TIMESTAMP)))", interval.start_time, interval.end_time, interval.end_time, interval.start_time])
  }

end