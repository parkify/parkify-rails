class CapacityList < ActiveRecord::Base
  attr_accessible :offer_id
  
  has_many :capacity_intervals
  
  belongs_to :offer
  

  
  
  #Note: ti contains quantity as capacity
  def add_if_can!(ti)
    
    intervals = capacity_intervals.overlapping(ti).order('start_time')
 
    toAdd = []
    if(intervals.size == 0) #no matches
      return false
    if(ti.start_time < intervals.first.start_time or ti.end_time > intervals.first.end_time) 
      return false
    end
    
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
    
      puts "------------------------------\n"
      puts intervals.first
      puts " "
      puts intervals.last
      puts " "
      puts "------------------------------\n"
    
    
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
    
    puts "------------------------------\n"
    puts "------------------------------\n"
    intervals.each do |i|
      puts i
      i.delete
    end
    puts "------------------------------\n"
    toAdd.each do |i|
      puts i
      i.save!
    end
    puts "------------------------------\n"
    
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
    
  def self.test2()
    CapacityList.destroy_all
    CapacityInterval.destroy_all
    
    a1 = CapacityList.create()
    b1 = a1.capacity_intervals.create({:capacity=>10, :start_time=>Time.at(0), :end_time=>Time.at(5)})
    b2 = a1.capacity_intervals.create({:capacity=>10, :start_time=>Time.at(5), :end_time=>Time.at(10)})
    
    b3 = CapacityInterval.new({:capacity=>1, :start_time=>Time.at(0), :end_time=>Time.at(7)})
    
    a1.add_if_can!(b3)
  end
  
  def self.test3()
    CapacityList.destroy_all
    CapacityInterval.destroy_all
    
    a1 = CapacityList.create()
    b1 = a1.capacity_intervals.create({:capacity=>10, :start_time=>Time.at(0), :end_time=>Time.at(5)})
    b2 = a1.capacity_intervals.create({:capacity=>10, :start_time=>Time.at(5), :end_time=>Time.at(10)})
    
    b3 = CapacityInterval.new({:capacity=>1, :start_time=>Time.at(3), :end_time=>Time.at(10)})
    
    a1.add_if_can!(b3)
  end
  def self.test4()
    CapacityList.destroy_all
    CapacityInterval.destroy_all
    
    a1 = CapacityList.create()
    b1 = a1.capacity_intervals.create({:capacity=>15, :start_time=>Time.at(0), :end_time=>Time.at(5)})
    b2 = a1.capacity_intervals.create({:capacity=>15, :start_time=>Time.at(5), :end_time=>Time.at(10)})
    b3 = a1.capacity_intervals.create({:capacity=>15, :start_time=>Time.at(10), :end_time=>Time.at(15)})
    
    b4 = CapacityInterval.new({:capacity=>1, :start_time=>Time.at(3), :end_time=>Time.at(12)})
    
    a1.add_if_can!(b4)
  end
  def self.test5()
    CapacityList.destroy_all
    CapacityInterval.destroy_all
    
    a1 = CapacityList.create()
    b1 = a1.capacity_intervals.create({:capacity=>15, :start_time=>Time.at(0), :end_time=>Time.at(5)})
    b2 = a1.capacity_intervals.create({:capacity=>15, :start_time=>Time.at(5), :end_time=>Time.at(10)})
    b3 = a1.capacity_intervals.create({:capacity=>15, :start_time=>Time.at(10), :end_time=>Time.at(15)})
    
    b4 = CapacityInterval.new({:capacity=>1, :start_time=>Time.at(3), :end_time=>Time.at(10)})
    
    a1.add_if_can!(b4)
  end
  
  def self.test6()
    CapacityList.destroy_all
    CapacityInterval.destroy_all
    
    a1 = CapacityList.create()
    b1 = a1.capacity_intervals.create({:capacity=>15, :start_time=>Time.at(0), :end_time=>Time.at(5)})
    b2 = a1.capacity_intervals.create({:capacity=>15, :start_time=>Time.at(5), :end_time=>Time.at(10)})
    b3 = a1.capacity_intervals.create({:capacity=>15, :start_time=>Time.at(10), :end_time=>Time.at(15)})
    
    b4 = CapacityInterval.new({:capacity=>1, :start_time=>Time.at(0), :end_time=>Time.at(15)})
    
    a1.add_if_can!(b4)
  end
  
  def self.test7()
    CapacityList.destroy_all
    CapacityInterval.destroy_all
    
    a1 = CapacityList.create()
    b1 = a1.capacity_intervals.create({:capacity=>15, :start_time=>Time.at(0), :end_time=>Time.at(5)})
    b2 = a1.capacity_intervals.create({:capacity=>15, :start_time=>Time.at(5), :end_time=>Time.at(10)})
    b3 = a1.capacity_intervals.create({:capacity=>15, :start_time=>Time.at(10), :end_time=>Time.at(15)})
    
    b4 = CapacityInterval.new({:capacity=>1, :start_time=>Time.at(0), :end_time=>Time.at(17)})
    
    a1.add_if_can!(b4)
  end
  
  def self.test8()
    CapacityList.destroy_all
    CapacityInterval.destroy_all
    
    a1 = CapacityList.create()
    b1 = a1.capacity_intervals.create({:capacity=>15, :start_time=>Time.at(0), :end_time=>Time.at(5)})
    b2 = a1.capacity_intervals.create({:capacity=>15, :start_time=>Time.at(5), :end_time=>Time.at(10)})
    b3 = a1.capacity_intervals.create({:capacity=>15, :start_time=>Time.at(10), :end_time=>Time.at(15)})
    
    b4 = CapacityInterval.new({:capacity=>1, :start_time=>Time.at(-2), :end_time=>Time.at(15)})
    
    a1.add_if_can!(b4)
  end
  
  
end
