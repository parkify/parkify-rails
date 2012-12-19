
class PriceInterval < ValuedInterval
  attr_accessor :price

  def initialize(start_time, end_time, price)
    self.start_time = start_time
    self.end_time = end_time
    self.price = price
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

  def self.from_hash(h)
    if(h && h["start_time"] && h["end_time"] && h["price"])
      new(Time.at(h["start_time"].to_f),Time.at(h["end_time"].to_f),h["price"])
    else
      p ["bad hash in PriceInterval::from_hash, ", h]
      nil
    end
  end

  #include PresentationMethods
end
