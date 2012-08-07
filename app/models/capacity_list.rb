class CapacityList < ActiveRecord::Base
  attr_accessible :offer_id
  
  has_many :capacity_intervals
  
  belongs_to :offer
  
  
  #Note: ti contains quantity as capacity
  def add_if_can!(ti)
    
    intervals = capacity_intervals.overlapping(ti)#.order('start_time')
 
    toAdd = []
    if(intervals.size == 0) #no matches
      return false
    elsif(intervals.size == 1) #both in one interval
      if(intervals[0].start_time != ti.start_time)
        puts "Left"
        toAdd << capacity_intervals.new({:capacity=>intervals[0].capacity, :start_time=>intervals[0].start_time, :end_time=>ti.start_time})
      end
      
      puts "Middle"
      toAdd << capacity_intervals.new({:capacity=>intervals[0].capacity-ti.capacity, :start_time=>ti.start_time, :end_time=>ti.end_time})
      
      if(intervals[0].end_time != ti.end_time)
        puts "Right"
        toAdd << capacity_intervals.new({:capacity=>intervals[0].capacity, :start_time=>ti.end_time, :end_time=>intervals[0].end_time})
      end
      #split  interval[0] into 3
    else  #both in their own interval
    
      #Left and Right
      if(intervals.first.start_time != ti.start_time)
        puts "[Left"
        toAdd << capacity_intervals.new({:capacity=>intervals.first.capacity, :start_time=>intervals.first.start_time, :end_time=>ti.start_time})
      end
        puts "LMiddle]"
        toAdd << capacity_intervals.new({:capacity=>intervals.first.capacity-ti.capacity, :start_time=>ti.start_time, :end_time=>intervals.first.end_time})
        puts "[RMiddle"
        toAdd << capacity_intervals.new({:capacity=>intervals.first.capacity-ti.capacity, :start_time=>intervals.last.start_time, :end_time=>ti.end_time})
      if(intervals.last.end_time != ti.end_time)
        puts "Right]"
        toAdd << capacity_intervals.new({:capacity=>intervals.last.capacity, :start_time=>ti.end_time, :end_time=>intervals.last.end_time})
      end
      
      #Middle
      if (intervals.size > 2)
        puts "[MMiddle]"
        intervals[1..-2].each{|i| toAdd << capacity_intervals.new({:capacity=>i.capacity - ti.capacity, :start_time=>i.start_time, :end_time=>i.end_time})}
      end
      
    end
    
    toAdd.each do |i|
      i.save!
    end
    intervals.each do |i|
      i.delete
    end
    
    return true
  end
  
  
  def self.test1()
    CapacityList.destroy_all
    CapacityInterval.destroy_all
    
    a1 = CapacityList.create()
    b1 = a1.capacity_intervals.create({:capacity=>10, :start_time=>Time.at(0), :end_time=>Time.at(5)})
    b2 = a1.capacity_intervals.create({:capacity=>10, :start_time=>Time.at(5), :end_time=>Time.at(10)})
    
    b3 = CapacityInterval.new({:capacity=>1, :start_time=>Time.at(3), :end_time=>Time.at(7)})
    
    a1.add_if_can!(b3)
    
    
    
  end
  
end
