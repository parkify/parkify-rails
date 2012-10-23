class Payment

  #Attempt to charge user (deduct from credit and/or charge active card)
  #amount is an integer representing the number of cents to be charged.
  #returns a payment info object
  #TODO: attach reason and user to paymentInfo
  def self.charge(user, amountToCharge, reason)
    if(amountToCharge < 0) #TODO: Put in warning for charging very large amounts\
      Payment::payment_failed(user, paymentInfo, reason, "Charge amount was negative")
      return nil
    end
  
    #Verify that user is valid
    if (!user)
      Payment::payment_failed(user, paymentInfo, reason, "User was invalid")
      return nil
    end
    
    #make a paymentInfo object
    paymentInfo = PaymentInfo.create()
    paymentInfo.amount_charged = amountToCharge
    
    #Try to charge everything from account credit first.
    partialamount_chargedFromCredit = 0
    if(user.credit > 0)
      if(user.credit >= amountToCharge)
        paymentInfo.details = "$#{amountToCharge/100} was deducted from account credits"
        user.credit -= amountToCharge
        Payment::payment_succeeded(user, paymentInfo, reason)
        paymentInfo.save
        return paymentInfo
      else
        partialamount_chargedFromCredit = user.credit
        amountToCharge -= partialamount_chargedFromCredit
        user.credit = 0.0
        
        paymentInfo.details = "$#{partialamount_chargedFromCredit/100} was deducted from account credits and "
      end
    end
    
    
    #verify that the user has a valid card and grab that card.
    customer = user.active_card
    if (!customer)
      Payment::payment_failed(user, paymentInfo, reason, "User has no active cards")
      return nil
    end
    
    paymentInfo.stripe_customer_id_id = customer.id
    
    #Try to charge the rest from the card. If there is less than 50c to charge, then make it free for now.
    #TODO: Figure out a better solution for the 50-cent restriction.
    #TODO: Make sure card charges are not blocking this thread
    if(amountToCharge >= 50)
      p amountToCharge
      begin
        charge = Stripe::Charge.create ({:amount=>amountToCharge.floor, :currency=>"usd", :customer => customer.customer_id, :description => "#{user.email}:#{reason}"})
      rescue
        reasonForError = "#{$!}"
        user.credit += partialamount_chargedFromCredit
        paymentInfo.amount_charged = 0
        paymentInfo.save
        Payment::payment_failed(user, paymentInfo, reason, reasonForError)
        return nil
      end
    
      if(charge.failure_message.nil?)
        Payment::payment_succeeded(user, paymentInfo, reason)
        paymentInfo.details += "$#{amountToCharge/100} was charged to card *#{charge.card.last4}"
        paymentInfo.save
        return paymentInfo
      else
        #give back credit.
        user.credit += partialamount_chargedFromCredit
        paymentInfo.amount_charged = 0
        paymentInfo.save
        Payment::payment_failed(user, paymentInfo, reason, "Stripe failed")
        return nil
      end
    
    else
      user.credit += partialamount_chargedFromCredit
      paymentInfo.amount_charged = 0
      paymentInfo.save
      Payment::payment_failed(user, paymentInfo, reason, "amount was less than 50c")
      return nil
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
  
end#don't forget to return paymentInfo obj.


    #customer = user.stripe_customer_ids.first #TODO: pick the one that is active instead
    #paymentInfo = self.create_payment_info()
    #paymentInfo.stripe_customer_id_id = customer.id
 
    #if(amountToCharge >= 50)
    #  charge = Stripe::Charge.create ({:amount=>amountToCharge, :currency=>"usd", :customer => customer.customer_id, :description => user.email})
    #
    #  if(charge.failure_message.nil?)
    #    self.status = "successfully_paid"
    #    paymentInfo.amount_charged = amountToCharge
    #    #def send_conf_email
    #    UserMailer.payment_succeeded_email(self.user, self, charge).deliver
    #    return true
    #  else
    #    self.status = "not_successfully_paid"
    #    interval.capacity = -interval.capacity
    #    offer.capacity_list.add_if_can!(interval)
    #    b_undo = true
    #  end
    #else
    #  if(amountToCharge < 0)
    #    b_undo = true
    #    self.status = "error: negative charge"
    #  else
    #    paymentInfo.amount_charged = 0
    #    self.status = "didn't need to pay"
    #  end
    #
    #end