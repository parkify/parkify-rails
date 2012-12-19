
class PriceInterval < ValuedInterval
  attr_accessor :price

  def initialize(start_time, end_time, price)
    @start_time_fl = start_time.to_f
    @end_time_fl = end_time.to_f
    @price = price
  end

  def contains(time)
    return time >= self.start_time && time <= self.end_time
  end
  
  def to_s()
    return "price:#{self.price} (from #{self.start_time} to #{self.end_time})"
  end

  def dp
    p [self.start_time, self.end_time, self.price]
  end

  def as_json(options={})
    {
      :start_time => "#{self.start_time.to_f}",
      :end_time => "#{self.end_time.to_f}",
      :price_per_hour => self.price
    }
  end

  def self.from_hash(h)
    if(h && h["start_time"] && h["end_time"] && h["price"])
      new(Time.at(h["start_time"].to_f),Time.at(h["end_time"].to_f),h["price"])
    else
      nil
    end
  end

  #include PresentationMethods
end
