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
    customer = user.stripe_customer_ids.first #TODO: pick the one that is active instead
    paymentInfo = self.create_payment_info()
    paymentInfo.stripe_customer_id_id = customer.id
    
    if(amountToCharge >= 50)
      charge = Stripe::Charge.create ({:amount=>amountToCharge, :currency=>"usd", :customer => customer.customer_id, :description => user.email})
    
      if(charge.failure_message.nil?)
        self.status = "successfully_paid"
        paymentInfo.amount_charged = amountToCharge
        #def send_conf_email
        UserMailer.payment_succeeded_email(self.user, self, charge).deliver
        return true
      else
        self.status = "not_successfully_paid"
        interval.capacity = -interval.capacity
        offer.capacity_list.add_if_can!(interval)
        b_undo = true
      end
    else
      if(amountToCharge < 0)
        b_undo = true
        self.status = "error: negative charge"
      else
        paymentInfo.amount_charged = 0
        self.status = "didn't need to pay"
      end
    
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


  #def self.build_and_charge_from_api(params)
  #  b_undo = false
  #  params = JSON.parse(params)
  #  logger.info "TEST: #{params}"
  #  user = User.find_by_authentication_token(params["authentication_token"])
  #  puts "--------------------------------"
  #  puts user
  #  puts params["authentication_token"]
  #  puts "--------------------------------"
  #  spot = Resource.find_by_id(params["parking_spot_id"].to_i)
  #  
  #  customer = user.stripe_customer_ids.first #TODO: pick the one that is active instead
  #  start_time = params["start_time"].to_f()
  #  end_time = params["end_time"].to_f()
  #  
  #  amountToCharge = 0.0
  #  params["offer_ids"].each do |offer_id|
  #  
  #    #grab the correct offer
  #    offer = Offer.find_by_id(offer_id.to_i)
  #    self.offers << offer
  #    
  #    #check if there is space
  #    eff_start_time = MAX(start_time, offer.start_time)
  #    eff_end_time = MIN(end_time, offer.end_time)
  #    if(eff_end_time < start_time)
  #      b_undo = true
  #      break 
  #    end
  #    interval = CapacityInterval.new({:start_time => eff_start_time, :end_time => eff_end_time, :capacity => 1})
  #    if(!offer.capacity_list.add_if_can!(interval))
  #      b_undo = true
  #      break
  #    end
  #    
  #    # find cost
  #    amountToCharge += offer.find_cost(eff_start_time, eff_end_time)
  #  end
  #  
  #  #uh oh, we failed somewhere. Time to clean up our mess.
  #  if(b_undo)
  #    self.offers[0...-1].each do |offer|
  #      
  #    end
  #    return [nil,nil]
  #  end
  #      
  #  paymentInfo = PaymentInfo.new
  #  paymentInfo.stripe_customer_id_id = customer.id
  #  paymentInfo.amount_charged = amountToCharge
  #  
  #  charge = Stripe::Charge.create ({:amount=>amountToCharge, :currency=>"usd", :customer => customer.customer_id, :description => user.email})
  #
  #  if(charge.failure_message.nil?)
  #    toRtn.status = "successfully_paid"
  #  else
  #    toRtn.status = "not_successfully_paid"
  #    interval.capacity = -interval.capacity
  #    offer.capacity_list.add_if_can!(interval)
  #  end
  #  
  #  return [self, paymentInfo]
  #  
  #  amountToCharge += findAmountToCharge
  #  amountToCharge = offer.price_plan.price_per_hour * (end_time - start_time) / 36 #convert to cents
  #  amountToCharge = amountToCharge.floor
  #  start_time = Time.at(start_time)
  #  end_time = Time.at(end_time)
  #  #check if this is a valid request.
  #  interval = CapacityInterval.new({:start_time => start_time, :end_time => end_time, :capacity => 1})
  #  puts interval
  #  puts offer
  #  if(offer.capacity_list.add_if_can!(interval))
  #    puts "Got here"
  #    toRtn = new()
  #    toRtn.user_id = user.id
  #    
  #    toRtn.offer_id = offer.id
  #    toRtn.start_time = Time.at(start_time)
  #    toRtn.end_time = Time.at(end_time)
  #    toRtn.status = "successfully_paid"
  #    toRtn.count = 1
  #    
  #    paymentInfo = PaymentInfo.new
  #    paymentInfo.stripe_customer_id_id = customer.id
  #    paymentInfo.amount_charged = amountToCharge
  #    
  #    #do charging
  #    
  #    charge = Stripe::Charge.create ({:amount=>amountToCharge, :currency=>"usd", :customer => customer.customer_id, :description => user.email})
  #
  #    if(charge.failure_message.nil?)
  #      toRtn.status = "successfully_paid"
  #    else
  #      toRtn.status = "not_successfully_paid"
  #      interval.capacity = -interval.capacity
  #      offer.capacity_list.add_if_can!(interval)
  #    end
  #    paymentInfo.stripe_charge_id = charge.id
  #    return [toRtn, paymentInfo]
  #  else
  #    return [nil, nil]
  #  end
  #end
end
