class Acceptance < ActiveRecord::Base
  attr_accessible :user_id, :count, :end_time, :start_time, :status, :card_id, :card

  belongs_to :user
  
  belongs_to :resource_offer

  has_one :card

  has_many :complaints
  after_save :update_handler
  after_destroy :update_handler
  # Just builds a blank acceptance, since acceptances need to be saved first before
  #   we can add member entities.
  # TODO: update
  #def as_json(options={})
  #  result = super(:only => [:id, :details])
  #  result
  #end
  
  # no longer used
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

  def check_with_resource_offer_handler(roh)
    
  end
  
  # Now try to validate, find the total cost, and charge with card.
  # If anything goes wrong, clean up and return false.
  # Assumes: that self has been saved.

  # TODO: TEST
  def add_offers_and_charge_from_api(params)
    params = JSON.parse(params)
    
    if(!self.user)
      self.status = "invalid user"
      return false
    end
    
    amountToCharge = 0.0


    interval = CapacityInterval.new({:start_time => self.start_time, :end_time => self.end_time, :capacity => 1})
    if(!resource_offer.add_if_can!(interval))
      self.status = "Resource not available for target capacity interval"
      return false
    end

    #now focus on payment
    self.status = "payment pending"
    amountToCharge = resource_offer.find_cost(self.start_time, self.end_time)
    amountToCharge = (amountToCharge * 100).floor #need value in cents

    paymentInfo = Payment::charge(user, amountToCharge, "Spot Reservation")
    self.payment_info = paymentInfo
    
    if !paymentInfo
      self.status = "not successfully paid"
      interval.capacity = -interval.capacity
      offer.capacity_list.add_if_can!(interval)
      return false
    else
      self.status = self.status_codes()["1"] 
      UserMailer.payment_succeeded_email(self.user, self).deliver
      return true
    end
  end

  def self.status_codes()
    return Hash["1"=>"successfully paid", "2"=>"not successfully paid", "3"=>"invalid user", "4"=>"invalid spot", "5"=>"scheduling failed", "6"=>"payment pending", "7"=>"not successfully paid"]
  end
def validate_and_charge()
    
    if(!self.user)
      self.status = "invalid user"
      self.errors.add(:user, "must be logged in")
      return false
    end
    
    resource_offer = ResourceOffer.find_by_id(self.resource_offer_id)
    if (!resource_offer)
      self.status = "invalid spot"
      self.errors.add(:spot, "is currently not available")
      return false
    end

    #TODO: serialize or transactionalize
    price = ResourceOfferHandler::validate_reservation_and_find_price(self.resource_offer_id, self.start_time, self.end_time, self.price_type)
    if (price < 0)    
      self.status = "scheduling failed"
      self.errors.add(:transaction, "failed")
      self.save
      return false
    end

    #now focus on payment
    self.status = "payment pending"
    amountToCharge = (price * 100).floor #need value in cents
    paymentInfo = Payment::charge(user, amountToCharge, "Spot Reservation")
    
    if !paymentInfo
      self.status = "payment failed"
      self.save
      return false
    else
      self.set_payment_info(paymentInfo)
      self.status = "successfully paid"
      self.save
      UserMailer.payment_succeeded_email(self.user, self).deliver
      return true
    end
  end
  
  def set_payment_info(paymentInfo)
    if(paymentInfo)
      self.amount_charged = paymentInfo.amount_charged
      self.stripe_charge_id = paymentInfo.stripe_charge_id
      self.card_id = paymentInfo.card_id
      self.details = paymentInfo.details
    end
  end
  def refund_payment
    if(self.stripe_charge_id)
      charge = Payment::refund(self.stripe_charge_id)
      if(charge.failure_message.nil?)
        self.status = "CC refunded" 
        self.save
        return "Credited $"+self.amount_charged.to_s()+" back to account"
      else
        p charge.failure_message
        return "Error processing refund please contact"
      end
    else
      self.status = "Credits refunded" 
      self.save

      user = User.find(self.user_id)
      user.credit = user.credit + self.amount_charged
      user.save
      return "Refunded $"+self.amount_charged.to_s()+" to account";
    end

  end
  
  # Check the price without making the purchase.
  def check_price(resource_offer_handler=nil)
    
    toRtn = {}
    toRtn[:price_string] = ""
     
    if(!self.user)
      toRtn[:price_string] = "invalid user"
      toRtn[:success] = false
      return toRtn
    end
    
    #grab correct price
    if(resource_offer_handler)
      price = resource_offer_handler.validate_reservation_and_find_price(self.resource_offer_id, self.start_time, self.end_time)
    else
      price = ResourceOfferHandler::validate_reservation_and_find_price(self.resource_offer_id, self.start_time, self.end_time)
    end

    if (price < 0)
      toRtn[:price_string] = "spot not available at this time"
      toRtn[:success] = false
      return toRtn
    end

    #now focus on payment
    amountToCharge = (price * 100).floor #need value in cents
    toRtn[:price_string] = Payment::charge_string(user, amountToCharge, "Spot Reservation")

    toRtn[:success] = !toRtn[:price_string].downcase.include?("error")
    return toRtn
  end


  def generate_working_schedule(start_time_in, end_time_in)
    toRtn = {:capacity_intervals => [], :price_intervals => []}
   
    start_time_to_generate = [start_time_in, self.start_time].max
    end_time_to_generate = [end_time_in, self.end_time].min

    if (end_time_to_generate > start_time_to_generate)
        toRtn[:capacity_intervals] << CapacityInterval.new(start_time_to_generate, end_time_to_generate, 0)
    end

    return toRtn
  end

  def card
    ch = Stripe::Charge.retrieve(self.stripe_charge_id)
    return ch.card
  end

 private
    def update_handler
      ApplicationController::update_resource_availability([self.resource_offer_id])
    end

end
