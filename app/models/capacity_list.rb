class CapacityList < ActiveRecord::Base
  attr_accessible :offer_id
  
  has_many :capacity_intervals
  
  belongs_to :offer
  
  
  #Note: ti contains quantity as capacity
  def add_if_can!(ti)
    intervals = capacity_intervals.select{|i| i.overlaps_with_interval(ti)}.order('start_time')
    toAdd = List()
    if(intervals.size == 0) #no matches
      return false
    elsif(intervals.size == 1) #both in one interval
      if(intervals[0].start_time != ti.start_time)
        toAdd << capacity_intervals.new({:capacity=>intervals[0].capacity, :start_time=>intervals[0].start_time, :end_time=>ti.start_time})
      end
        toAdd << capacity_intervals.new({:capacity=>intervals[0].capacity-ti.capacity, :start_time=>intervals[0].start_time, :end_time=>ti.start_time})
      if(intervals[0].end_time != ti.end_time)
        toAdd << capacity_intervals.new({:capacity=>intervals[0].capacity, :start_time=>ti.end_time, :end_time=>intervals[0].end_time})
      end
      #split  interval[0] into 3
    elsif(intervals.size == 2) #both in adjacent intervals
    #  if(intervals[0].start_time != ti.start_time)
   #     toAdd << capacity_intervals.new({:capacity=>intervals[0].capacity, :start_time=>intervals[0].start_time, :end_time=>ti.start_time})
    #  end
    #    toAdd << capacity_intervals.new({:capacity=>intervals[0].capacity-ti.capacity, :start_time=>intervals[0].start_time, :end_time=>ti.start_time})
    #  if(intervals[0].end_time != ti.end_time)
    #    toAdd << capacity_intervals.new({:capacity=>intervals[0].capacity, :start_time=>ti.end_time, :end_time=>intervals[0].end_time})
    #  end
    else #intervals in between
    
    end
  end
  
end
