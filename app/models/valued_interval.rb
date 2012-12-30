class ValuedInterval

  attr_accessor :start_time_fl
  attr_accessor :end_time_fl

  def start_time=(t)
    @start_time_fl = t.to_f
  end
  def start_time
    Time.at(@start_time_fl)
  end
  
  def end_time=(t)
    @end_time_fl = t.to_f
  end
  def end_time
    Time.at(@end_time_fl)
  end

  def initialize(start_time, end_time)
    self.start_time = start_time
    self.end_time = end_time
  end

  def overlapping?(x)
    #DEBUG    
    if !@end_time || !@start_time
      p ["ValuedInterval::overlapping?", self, @end_time, @start_time]
    end
    #END
    return (@end_time - x.start_time) * (x.end_time - @start_time) > 0
  end

  def self.force_intervals(intervals_forcing, intervals_onto_in)
    intervals_onto = intervals_onto_in.dup
    intervals_forcing.each do |vi_forcing|
      #DEBUG
      if !vi_forcing
        p ["ValudedInterval::force_intervals", intervals_forcing]
        break
      end
      #END
      #Find and split any overlapping intervals
      toRemove = []
      toAdd = []
      intervals_onto.select{|x| x.overlapping?(vi_forcing)}.each do |vi_onto|
        if vi_onto.start_time < vi_forcing.start_time
          split_left = vi_onto.clone
          split_left.end_time = vi_forcing.start_time
          toAdd << split_left
        end
        if vi_onto.end_time > vi_forcing.end_time
          split_right = vi_onto.clone
          split_right.start_time = vi_forcing.end_time
          toAdd << split_right
        end

        toAdd << vi_forcing
        toRemove << vi_onto
      end
      intervals_onto += toAdd      
      intervals_onto -= toRemove
    end
    return intervals_onto
  end

  def dp
    p [@start_time, @end_time]
  end

  def self.from_hash(h)
    if(h && h["start_time_fl"] && h["end_time_fl"])
      new(Time.at(h["start_time_fl"].to_f),Time.at(h["end_time_fl"].to_f))
    else  
      p ["bad hash in ValuedInterval::from_hash, ", h]
      nil
    end
  end

end

