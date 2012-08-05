class CapacityList < ActiveRecord::Base
  attr_accessible :offer_id
  
  has_many :capacity_intervals
  
  belongs_to :offer
  
  
  #Note: ti contains quantity as capacity
  def add_if_can!(ti)
    intervals = capacity_intervals.where{|i| i.overlaps_with_interval(ti)}.order('start_time')
    toAdd = []
    if(intervals.size == 0) #no matches
      return false
    elsif(intervals.size == 1) #both in one interval
      if(intervals[0].start_time != ti.start_time)
        toAdd << capacity_intervals.new({:capacity=>intervals[0].capacity, :start_time=>intervals[0].start_time, :end_time=>ti.start_time})
      end
       
      toAdd << capacity_intervals.new({:capacity=>intervals[0].capacity-ti.capacity, :start_time=>ti.start_time, :end_time=>ti.end_time})
      
      if(intervals[0].end_time != ti.end_time)
        toAdd << capacity_intervals.new({:capacity=>intervals[0].capacity, :start_time=>ti.end_time, :end_time=>intervals[0].end_time})
      end
      #split  interval[0] into 3
    else  #both in their own interval
    
      #Left and Right
      if(intervals.first.start_time != ti.start_time)
        toAdd << capacity_intervals.new({:capacity=>intervals.first.capacity, :start_time=>intervals.first.start_time, :end_time=>ti.start_time})
      end
        toAdd << capacity_intervals.new({:capacity=>intervals.first.capacity-ti.capacity, :start_time=>ti.start_time, :end_time=>intervals.first.end_time})
        toAdd << capacity_intervals.new({:capacity=>intervals.first.capacity-ti.capacity, :start_time=>intervals.last.start_time, :end_time=>ti.end_time})
      if(intervals.last.end_time != ti.end_time)
        toAdd << capacity_intervals.new({:capacity=>intervals.last.capacity, :start_time=>ti.end_time, :end_time=>intervals.last.end_time})
      end
      
      #Middle
      if (intervals.size > 2)
        intervals[1..-2].each{|i| toAdd << capacity_intervals.new({:capacity=>i.capacity - ti.capacity, :start_time=>i.start_time, :end_time=>i.end_time})}
      end
      
      toAdd.each{|i| i.save}
      intervals.each{|i| i.delete}
    end
  end
  
end
