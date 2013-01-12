
class PriceInterval < ValuedInterval
  attr_accessor :price
  attr_accessor :flat_rate_prices #

  def initialize(start_time, end_time, price, flat_rate_prices)
    self.start_time = start_time
    self.end_time = end_time
    self.price = price
    self.flat_rate_prices = flat_rate_prices
  end

  def contains(time)
    return time >= self.start_time && time <= self.end_time
  end
  
  def to_s()
    return "price:#{self.price} (from #{self.start_time} to #{self.end_time})"
  end

  def dp
    p [self.start_time, self.end_time, self.price, self.flat_rate_prices]
  end

  def self.from_hash(h)
    if(h && h["start_time_fl"] && h["end_time_fl"] && h["price"])
      new(Time.at(h["start_time_fl"].to_f),Time.at(h["end_time_fl"].to_f),h["price"], h["flat_rate_prices"])
    else
      p ["bad hash in PriceInterval::from_hash, ", h]
      nil
    end
  end

  #include PresentationMethods
end
