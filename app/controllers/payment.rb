class Payment

  #Attempt to charge user (deduct from credit and/or charge active card)
  #amount is an integer representing the number of cents to be charged.
  #returns a payment info object
  #TODO: attach reason and user to paymentInfo
  def self.charge(user, amountToCharge, reason)
    
    paymentInfo = PaymentInfo.new()
    paymentInfo.amount_charged = amountToCharge
    paymentInfo.details = ""
    if(amountToCharge < 0) #TODO: Put in warning for charging very large amounts\
      Payment::payment_failed(user, paymentInfo, reason, "Charge amount was negative")
      return nil
    end
  
    #Verify that user is valid
    if (!user)
      Payment::payment_failed(user, paymentInfo, reason, "User was invalid")
      return nil
    end
    
    #consider discounts first 
    discountedAmountToCharge = amountToCharge
    user.promos.each do |p|
      if p.of_type?('discount')
        discountedAmountToCharge = [discountedAmountToCharge, p.discount(amountToCharge)].min
      end
    end
    
    discountedString = ""
    if(amountToCharge != discountedAmountToCharge)
      discountedString = " (after discounts)"
      amountToCharge = discountedAmountToCharge
    end
    
    
    
    
    #Try to charge everything from account credit first.
    partialamount_chargedFromCredit = 0
    if(user.credit > 0)
      if(user.credit >= amountToCharge)
        paymentInfo.details = "$#{sprintf('%0.2f',amountToCharge/100.0)} was deducted from account credits" + discountedString
        user.credit -= amountToCharge
        user.save
        Payment::payment_succeeded(user, paymentInfo, reason)
        return paymentInfo
      else
        partialamount_chargedFromCredit = user.credit
        amountToCharge -= partialamount_chargedFromCredit
        user.credit = 0.0
        user.save
        
        paymentInfo.details = "$#{sprintf('%0.2f',partialamount_chargedFromCredit/100.0)} was deducted from account credits and "
      end
    end
    
    
    #verify that the user has a valid card and grab that card.
    customer = user.active_card
    if (!customer)
      if (user.trial?)
        user.credit += partialamount_chargedFromCredit
        user.save
        paymentInfo.amount_charged = 0
        Payment::payment_failed(user, paymentInfo, reason, "User has no active cards")
        return nil
      else
        user.credit += partialamount_chargedFromCredit
        user.save
        paymentInfo.amount_charged = 0
        Payment::payment_failed(user, paymentInfo, reason, "User has no active cards")
        return nil
      end
    end
    
    paymentInfo.card_id = customer.id
    
    #Try to charge the rest from the card. If there is less than 50c to charge, then make it free for now.
    #TODO: Figure out a better solution for the 50-cent restriction.
    #TODO: Make sure card charges are not blocking this thread
    if(amountToCharge >= 50)
      begin
        charge = Stripe::Charge.create ({:amount=>amountToCharge.floor, :currency=>"usd", :customer => customer.customer_id, :description => "#{user.email}:#{reason}"})
      rescue
        reasonForError = "#{$!}"
        user.credit += partialamount_chargedFromCredit
        user.save
        paymentInfo.amount_charged = 0
        Payment::payment_failed(user, paymentInfo, reason, reasonForError)
        return nil
      end
    
      if(charge.failure_message.nil?)
        Payment::payment_succeeded(user, paymentInfo, reason)
        paymentInfo.stripe_charge_id = charge["id"]
        paymentInfo.details += "$#{sprintf('%0.2f',amountToCharge/100.0)} was charged to card *#{charge.card.last4}" + discountedString
        return paymentInfo
      else
        #give back credit.
        user.credit += partialamount_chargedFromCredit
        user.save
        paymentInfo.amount_charged = 0
        Payment::payment_failed(user, paymentInfo, reason, "Stripe failed")
        return nil
      end
    
    else
      #for now, just give it to them for free.
      Payment::payment_succeeded(user, paymentInfo, reason)
      paymentInfo.details += "$#{sprintf('%0.2f',amountToCharge/100.0)} was charged to credit card" + discountedString
      return paymentInfo
    end
    
  end
  
  
  def self.refund(chargeToRefund)
    p "refunding charge" + chargeToRefund
    charge = Stripe::Charge.retrieve(chargeToRefund)
    charge.refund
    return charge
      if(charge.failure_message.nil?)
        return true
      else
        p "failed"
        #give back credit.
        return false 

      end
  end
  #Don't attempt to charge user, but instead find how much it will cost, etc
  def self.charge_string(user, amountToCharge, reason)
    if(amountToCharge < 0) #TODO: Put in warning for charging very large amounts\
      return "Error"
    end
  
    #Verify that user is valid
    if (!user)
      return "Error"
    end
    
    #consider discounts first
    discountedAmountToCharge = amountToCharge
    user.promos.each do |p|
      if p.of_type?('discount')
        discountedAmountToCharge = [discountedAmountToCharge, p.discount(amountToCharge)].min
      end
    end
    
    discountedString = ""
    if(amountToCharge != discountedAmountToCharge)
      discountedString = " (after discounts)"
      amountToCharge = discountedAmountToCharge
    end
    
    #Try to charge everything from account credit first.
    partialamount_chargedFromCredit = 0
    toRtn = ""
    if(user.credit > 0)
      if(user.credit >= amountToCharge)
        return "$#{sprintf('%0.2f',(amountToCharge/100.0))} will be deducted from account credits" + discountedString
      else
        partialamount_chargedFromCredit = user.credit
        amountToCharge -= partialamount_chargedFromCredit
        toRtn = "$#{sprintf('%0.2f',(partialamount_chargedFromCredit/100.0))} will be deducted from account credits and "
      end
    end
    
    
    #verify that the user has a valid card and grab that card.
    customer = user.active_card
    if (!customer)
      return "Error: You don't have an active credit card! Add a card in account settings or call 1-855-Parkify for assistance."
    end
    
    card = Stripe::Customer.retrieve(customer.customer_id).active_card
    
    if(amountToCharge >= 50)
      return toRtn + "$#{sprintf('%0.2f',(amountToCharge/100.0))} will be charged to card *#{card.last4}" + discountedString
    else
        #for now, just give it to them.
        return toRtn + "$#{sprintf('%0.2f',(amountToCharge/100.0))} will be charged to card *#{card.last4}" + discountedString
        
        #return "Error"
    end
    
  end
  
  
  
  
    
    
  def self.payment_succeeded(user, paymentInfo, reason)
    #STUB
    Rails.logger.info "Payment succeeded: (#{paymentInfo.amount_charged} cents) taken mercilessly from (user #{user.email}) because (#{reason})"
  end

  
  def self.payment_failed(user, paymentInfo, reason, reasonForFailure)
    #STUB
    Rails.logger.info "Payment failed: (for #{reason}) (user #{user.email}) failed because #{reasonForFailure})"
  end
  
end

class PaymentInfo
  attr_accessor :amount_charged
  attr_accessor :stripe_charge_id
  attr_accessor :card_id
  attr_accessor :details
end
