class UserMailer < ActionMailer::Base
  default from: "support@parkify.me"

  def welcome_email(user)
    @user = user
    mail(:to => user.email, :subject => "Welcome to Parkify!")
  end
  
  def payment_succeeded_email(user, acceptance, charge)
    @user = user
    @acceptance = acceptance
    #make the assumption that all offers are for the same resource
    @spot = acceptance.offers[0].resource
    
    @card = charge.card
    mail(:to => user.email, :subject => "Successful Reservation of Spot")
  end
end
