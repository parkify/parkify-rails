class Acceptance < ActiveRecord::Base
  attr_accessible :user_id, :count, :end_time, :start_time, :status
  
  
  belongs_to :user
  
  has_one :payment_info
  belongs_to :car
  
  has_many :agreements
  has_many :offers, :through => :agreements
  
  # Just builds a blank acceptance, since acceptances need to be saved first before
  #   we can add member entities.
  
  
  
  def self.build_from_api(params)
    params = JSON.parse(params)
    
    toRtn = new()
    toRtn.status = "pending"
    toRtn.user = User.find_by_authentication_token(params["authentication_token"])
    toRtn.start_time = Time.at(params["start_time"].to_f())
    toRtn.end_time = Time.at(params["end_time"].to_f())
    
    if(toRtn.end_time <= toRtn.start_time)
      return nil
    end
    
    toRtn
  end
  
  # Now try to validate, find the total cost, and charge with card.
  # If anything goes wrong, clean up and return false.
  # Assumes: that self has been saved.
  def add_offers_and_charge_from_api(params)
    params = JSON.parse(params)
    
    if(!self.user)
      self.status = "invalid user"
      return false
    end
    
    b_undo = false
    amountToCharge = 0.0
    offers_to_add = []
    params["offer_ids"].each do |offer_id|
    
      #grab the correct offer
      offer = Offer.find_by_id(offer_id.to_i)
      offers_to_add << offer
      
      #check if there is space
      eff_start_time = [self.start_time, offer.start_time].max
      eff_end_time = [self.end_time, offer.end_time].min
      if(eff_end_time < start_time)
        b_undo = true
        self.status = "invalid timing"
        break 
      end
      interval = CapacityInterval.new({:start_time => eff_start_time, :end_time => eff_end_time, :capacity => 1})
      if(!offer.capacity_list.add_if_can!(interval))
        b_undo = true
        self.status = "not enough capacity"
        break
      end
      
      # find cost
      amountToCharge += offer.find_cost(eff_start_time, eff_end_time)
    end
      
    #uh oh, we failed somewhere. Time to clean up our mess.
    if(b_undo)
      offers_to_add[0...-1].each do |offer|
        eff_start_time = [self.start_time, offer.start_time].max
        eff_end_time = [self.end_time, offer.end_time].min
        interval = CapacityInterval.new({:start_time => eff_start_time, :end_time => eff_end_time, :capacity => -1})
        offer.capacity_list.add_if_can!(interval)
      end
      return false
    else
      offers_to_add.each do |offer|
        Agreement.create({:acceptance_id => self.id, :offer_id => offer.id})
        
       # self.offers << offer
      end
    end
    
    self.status = "payment pending"
  
    #now focus on payment
    
    
    
    
    amountToCharge = (amountToCharge * 100).floor #need value in cents
    
    #TODO: Add better detail for this charge
    paymentInfo = Payment::Charge(user, amountToCharge, "Spot Reservation")
    
    if !paymentInfo
      self.status = "not_successfully_paid"
      interval.capacity = -interval.capacity
      offer.capacity_list.add_if_can!(interval)
      offer.capacity_list.add_if_can!(interval)
      b_undo = true
    else
      UserMailer.payment_succeeded_email(self.user, self).deliver
      return true
    end
    
    
    
    #uh oh, we failed somewhere. Time to clean up our mess.
    if(b_undo)
      offers_to_add[0...-1].each do |offer|
        eff_start_time = [self.start_time, offer.start_time].max
        eff_end_time = [self.end_time, offer.end_time].min
        interval = CapacityInterval.new({:start_time => eff_start_time, :end_time => eff_end_time, :capacity => -1})
        offer.capacity_list.add_if_can!(interval)
      end
      return false
    end
    
    
  end

end
