class ResourceOffer < ActiveRecord::Base

  attr_accessible :active, :description, :offer_schedules, :offer_schedule_exceptions
  attr_accessible :sign_id, :title, :user_id, :images, :location, :price_intervals
  attr_accessible :capacity_intervals, :created_at, :directions, :id, :latitude
  attr_accessible :location_address, :longitude, :plain_directions, :updated_at
  attr_accessible :location_name

  has_many :images, :as => :imageable

  has_many :quick_properties

  has_many :acceptances 
  has_many :offer_schedules 
  has_many :offer_schedule_exceptions 

  belongs_to :user 

  after_save :update_handler

  # Previously was used when we didn't have the sign_id attribute.
  # TODO: phase out.
  def pretty_id
    return self.sign_id
  end

  # Only ResourceOffers active in the interval [Now, Now+MAX_TIMEFRAME_VIEW_SIZE] are considered active.
  def MAX_TIMEFRAME_VIEW_SIZE 
    return 5*3600
  end

  # If current, returns the beginning of the active interval. Else returns 0.
  def start_time
    #toRtn = Time.now
    capIntervals = capacity_intervals.where("start_time <= ?", Time.now).order("start_time DESC")
    if(capIntervals.size == 0)
      return 1
    end
    if(capIntervals.first.capacity < 1)
      return 2
    end
    if(capIntervals.first.end_time < Time.now)
      return 3
    end

    earliest_cap = capIntervals.first
    earliest_time = earliest_cap.start_time

    capIntervals[1..-1].each do |capIter|
      if(capIter.end_time != earliest_time || capIter.capacity < 1)
        break;
      end

      earliest_cap = capIter
      earliest_time = capIter.start_time
    end

    return earliest_time
  end

  # If current, returns the end of the active interval. Else returns 0.
  def end_time
    capIntervals = capacity_intervals.where("end_time >= ?", Time.now).order("start_time ASC")
    if(capIntervals.size == 0)
      return 0
    end
    if(capIntervals.first.capacity < 1)
      return 0
    end
    if(capIntervals.first.start_time > Time.now)
      return 0
    end

    latest_cap = capIntervals.first
    latest_time = latest_cap.end_time

    capIntervals[1..-1].each do |capIter|
      if(capIter.start_time != latest_time || capIter.capacity < 1)
        break;
      end

      latest_cap = capIter
      latest_time = capIter.end_time
    end

    return latest_time
  end

  # Returns whether or not this ResourceOffer is current. Defunct.
  #def is_current
  #  return (self.start_time <= Time.now) && (Time.now <= self.end_time)
  #end

  # Previously used when Resource and Offer were two separate entities.
  # TODO: Phase out.
  def eff_location
    return self.location
  end

  # Previously used when Resource and Offer were two separate entities.
  # TODO: Phase out.
  def updateWithParent!
    return self.save!
  end


  # Check if we can accept the input capacityInterval.
  def can_add?(ti)
    intervals = self.capacity_intervals.overlapping(ti).order('start_time')
    
    does_not_fit = false
    intervals.each do |i|
      does_not_fit = does_not_fit || (i.capacity-ti.capacity < 0)
    end
 
    toAdd = []
    if(intervals.size == 0)
      return false
    elsif(ti.start_time < intervals.first.start_time or ti.end_time > intervals.last.end_time) 
      return false
    elsif(does_not_fit)
      return false
    elsif(intervals.size == 1) #both in one interval    
      if(intervals[0].start_time != ti.start_time)
        toAdd << capacity_intervals.new({:capacity=>intervals[0].capacity, :start_time=>intervals[0].start_time, :end_time=>ti.start_time})
      end
      
      toAdd << capacity_intervals.new({:capacity=>intervals[0].capacity-ti.capacity, :start_time=>ti.start_time, :end_time=>ti.end_time})
      
      if(intervals[0].end_time != ti.end_time)
        toAdd << capacity_intervals.new({:capacity=>intervals[0].capacity, :start_time=>ti.end_time, :end_time=>intervals[0].end_time})
      end
      
    else  #both in their own interval
    
      #Left and Right
      if(intervals.first.start_time != ti.start_time)
        #puts "[Left"
        toAdd << capacity_intervals.new({:capacity=>intervals.first.capacity, :start_time=>intervals.first.start_time, :end_time=>ti.start_time})
      end
        #puts "LMiddle]"
        toAdd << capacity_intervals.new({:capacity=>intervals.first.capacity-ti.capacity, :start_time=>ti.start_time, :end_time=>intervals.first.end_time})
        #puts "[RMiddle"
        toAdd << capacity_intervals.new({:capacity=>intervals.first.capacity-ti.capacity, :start_time=>intervals.last.start_time, :end_time=>ti.end_time})
      if(intervals.last.end_time != ti.end_time)
        #puts "Right]"
        toAdd << capacity_intervals.new({:capacity=>intervals.last.capacity, :start_time=>ti.end_time, :end_time=>intervals.last.end_time})
      end
      
      #Middle
      if (intervals.size > 2)
        #puts "[MMiddle]"
        intervals[1..-2].each{|i| toAdd << capacity_intervals.new({:capacity=>i.capacity - ti.capacity, :start_time=>i.start_time, :end_time=>i.end_time})}
      end
      
    end
    
    return true
  end

  
  # Adds in the input capacityInterval in our set of capacity intervals (if possible).
  def add_if_can!(ti)
    
    intervals = self.capacity_intervals.overlapping(ti).order('start_time')
    
    does_not_fit = false
    intervals.each do |i|
      does_not_fit = does_not_fit || (i.capacity-ti.capacity < 0)
    end
 
    toAdd = []
    if(intervals.size == 0)
      return false
    elsif(ti.start_time < intervals.first.start_time or ti.end_time > intervals.last.end_time) 
      return false
    elsif(does_not_fit)
      return false
    elsif(intervals.size == 1) #both in one interval    
      if(intervals[0].start_time != ti.start_time)
        toAdd << capacity_intervals.new({:capacity=>intervals[0].capacity, :start_time=>intervals[0].start_time, :end_time=>ti.start_time})
      end
      
      toAdd << capacity_intervals.new({:capacity=>intervals[0].capacity-ti.capacity, :start_time=>ti.start_time, :end_time=>ti.end_time})
      
      if(intervals[0].end_time != ti.end_time)
        toAdd << capacity_intervals.new({:capacity=>intervals[0].capacity, :start_time=>ti.end_time, :end_time=>intervals[0].end_time})
      end
      
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
      
    end
    
    intervals.each do |i|
      i.delete
    end
    toAdd.each do |i|
      i.save!
    end
    
    return true
  end

  def xml_directions
    begin
      directions_hash = ActiveSupport::JSON.decode(self.directions)
    rescue
      return self.directions
    end

    instructions = directions_hash["sources"][0]
    toRtn = "<Directions>"

    instructions.each do |inst|
      toRtn += "<Direction>"
      if(inst["conds"][0]["text"])
        toRtn += "<Text>#{inst["conds"][0]["text"]}</Text>"
      end
      if(inst["conds"][0]["image"])
        toRtn += "<Image name='#{inst["conds"][0]["image"]}'/>"
      end
      toRtn += "</Direction>"
    end    

    toRtn += "</Directions>"

    return toRtn
  end

  def validate_directions
    begin
      directions_hash = ActiveSupport::JSON.decode(self.directions)
    rescue
      return false
    end

    begin
      instructions = directions_hash["sources"][0]
    rescue
      return false
    end

    instructions.each do |inst|
      begin
        inst["conds"][0]["text"]
      rescue
        return false
      end

      if(inst["conds"][0]["text"].nil?)
        return false
      end
    end  

    return true
  end

  def default_parking_directions
    return "{
    \"sources\": [
      [
        {
          \"location\":{\"lat\":#{self.latitude}, \"long\":#{self.longitude}},
          \"heading\":1.571,
          \"conds\": [
            {
              \"text\":\"Sorry, couldn't find parking directions.\"
            }
          ]
        }
      ]
    ]
  }"
  end

  def safe_directions
    if(self.validate_directions)
      return self.directions
    else
      return self.default_parking_directions
    end
  end


  def update_handler
    ResourceOfferContainer::update_spot(self.id, true)
  end

end
