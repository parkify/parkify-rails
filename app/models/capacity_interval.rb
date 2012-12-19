class CapacityInterval < ValuedInterval
  attr_accessor :capacity

  def initialize(start_time, end_time, capacity)
    self.start_time = start_time
    self.end_time = end_time
    self.capacity = capacity
  end

  def contains(time)
    return time >= self.start_time && time <= self.end_time
  end
  
  def to_s()
    return "capacity:#{self.capacity} (from #{self.start_time} to #{self.end_time})"
  end

  def dp
    p [self.start_time, self.end_time, self.capacity]
  end

  def as_json(options={})
    {
      :start_time => "#{self.start_time.to_f}",
      :end_time => "#{self.end_time.to_f}",
      :capacity => self.capacity
    }
  end

  def self.from_hash(h)
    if(h && h["start_time_fl"] && h["end_time_fl"] && h["capacity"])
      new(Time.at(h["start_time_fl"].to_f),Time.at(h["end_time_fl"].to_f),h["capacity"])
    else
      p ["bad hash in CapacityInterval::from_hash, ", h]
      nil
    end
  end

  #include PresentationMethods
end
