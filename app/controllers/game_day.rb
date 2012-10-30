# TODO: Make general
class GameDay
  attr_accessor :start_time
  attr_accessor :end_time
  
  def initialize(start_time, end_time)
    @start_time = start_time
    @end_time = end_time
  end
  

  #todo: double-check validity.
  def changePrice(pr,spots)
    spots.each do |i|
      s = Resource.find_by_id(i)
      offer = s.offers.order(:created_at).last
      p = offer.price_plan
      
      current = nil
      p.price_intervals.each do |pr|
        if(pr.start_time <= Time.now and pr.end_time >= Time.now)
          current = pr
          break
        end
      end
      
      if(current)
        current.price_per_hour=pr
        current.save
      end
    end
  end

  
  def gdPrice(pr, spots)
    a = @start_time
    b = @end_time
    
    spots.each do |i|
      s = Resource.find_by_id(i)
      offer = s.offers.order(:created_at).last
      p = offer.price_plan
      pint = p.price_intervals.order(:start_time).last
      
      
      
      x = p.price_intervals.new()
      x.start_time=a
      x.end_time=b
      x.price_per_hour=pr
      y = p.price_intervals.new()
      y.start_time=b
      y.end_time=pint.end_time
      y.price_per_hour=pint.price_per_hour
      pint.end_time=a
      
      pint.save
      x.save
      y.save
      p.price_intervals << x
      p.price_intervals << y
      
    end
  end
  
  
  #untested
  def gdAdjust(spots,start_time=@start_time, end_time=@end_time)
    a = start_time
    b = end_time
    
    spots.each do |i|
      s = Resource.find_by_id(i)
      offer = s.offers.order(:created_at).last
      p = offer.price_plan
      pint = p.price_intervals.order(:start_time).last
      
      
      bef = p.price_intervals.where('end_time = ?', @start_time).first
      cur = p.price_intervals.where('start_time = ? and end_time = ?', @start_time, @end_time).first
      aft = p.price_intervals.where('start_time = ? and end_time = ?', @start_time, @end_time).first
      
      #todo: fix so this adjusts correctly.
      if(bef)
        bef.end_time = end_time
        bef.save
      end
      if(cur)
        cur.start_time = start_time
        cur.end_time = end_time
        cur.save
      end
      if(aft)
        aft.start_time = start_time
        aft.save
      end
    end
  end
  
  
  
  
  #todo: double-check validity.
  def quickOffer(spots)
    a = Time.new(2012,10,6,5,0,0, "-07:00") ##offered before 5 for convenience with the above method.
    b = Time.new(2012,10,7,9,0,0, "-07:00")
  
    spots.each do |i|
      resource = Resource.find(i)
    
      #TODO: fix DST
      offer = resource.offers.new({:start_time => a, :end_time => b})
      if resource.save
          if offer.save
            offer.updateWithParent!
          end
      end
    end
  end
  
  
  
end