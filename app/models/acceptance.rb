class Acceptance < ActiveRecord::Base
  attr_accessible :user_id, :count, :end_time, :start_time, :status
  
  
  belongs_to :user
  
  has_one :payment_info
  
  has_many :agreements
  has_many :offers, :through => :agreements
  
  def self.build_and_charge_from_api(params)
    params = JSON.parse(params)
    logger.info "TEST: #{params}"
    user = User.find_by_authentication_token(params["authentication_token"])
    puts "--------------------------------"
    puts user
    puts params["authentication_token"]
    puts "--------------------------------"
    spot = Resource.find_by_id(params["parking_spot_id"].to_i)
    
    customer = user.stripe_customer_ids.first #TODO: pick the one that is active instead
    start_time = params["start_time"].to_f()
    end_time = params["end_time"].to_f()
    
    amountToCharge = 0.0
    params["offer_ids"].each do |offer_id|
    
      #grab the correct offer
      offer = Offer.find_by_id(offer_id.to_i)
      self.offers << offer
      
      # check if there is space
      eff_start_time = MAX(start_time, 
      interval = CapacityInterval.new({:start_time => eff_start_time, :eff_end_time => end_time, :capacity => 1})
      offer.capacity_list.add_if_can!(interval)
      
      # find cost
      amountToCharge += offer.find_cost(start_time, end_time)
    end
    
    
    
    
    amountToCharge += findAmountToCharge
    amountToCharge = offer.price_plan.price_per_hour * (end_time - start_time) / 36 #convert to cents
    amountToCharge = amountToCharge.floor
    start_time = Time.at(start_time)
    end_time = Time.at(end_time)
    #check if this is a valid request.
    interval = CapacityInterval.new({:start_time => start_time, :end_time => end_time, :capacity => 1})
    puts interval
    puts offer
    if(offer.capacity_list.add_if_can!(interval))
      puts "Got here"
      toRtn = new()
      toRtn.user_id = user.id
      
      toRtn.offer_id = offer.id
      toRtn.start_time = Time.at(start_time)
      toRtn.end_time = Time.at(end_time)
      toRtn.status = "successfully_paid"
      toRtn.count = 1
      
      paymentInfo = PaymentInfo.new
      paymentInfo.stripe_customer_id_id = customer.id
      paymentInfo.amount_charged = amountToCharge
      
      #do charging
      
      charge = Stripe::Charge.create ({:amount=>amountToCharge, :currency=>"usd", :customer => customer.customer_id, :description => user.email})

      if(charge.failure_message.nil?)
        toRtn.status = "successfully_paid"
      else
        toRtn.status = "not_successfully_paid"
        interval.capacity = -interval.capacity
        offer.capacity_list.add_if_can!(interval)
      end
      paymentInfo.stripe_charge_id = charge.id
      return [toRtn, paymentInfo]
    else
      return [nil, nil]
    end
  end
end
