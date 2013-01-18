=begin
class HipchatMailer < 
  default from: "support@parkify.me"

  def post(room)
    @user = user
    mail(:to => user.email, :subject => "Welcome to Parkify!")
  end
  
  def payment_succeeded_email(user, acceptance)
    @user = user
    @acceptance = acceptance
    #make the assumption that all offers are for the same resource
    @spot = acceptance.resource_offer
    
    
    mail(:to => user.email, :subject => "Successful Reservation of Spot")
  end
  def trouble_with_spot_email(spot, complaint, user, shouldCancel)
    p 'sending email'
    @user = user
    @spot = spot
    @complaint = complaint
    @shouldCancel = shouldCancel
    mail(:to =>"gnamit@gmail.com",  :subject=>"Problem with spot")

  end
end
=end
