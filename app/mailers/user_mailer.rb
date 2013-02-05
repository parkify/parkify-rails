class UserMailer < ActionMailer::Base
  default from: "support@parkify.me"

  def welcome_email(user)
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
    p 'sending  email'
    @user = user
    @spot = spot
    @complaint = complaint
    @shouldCancel = shouldCancel
    mail(:to =>"dylan.r.jackson@parify.me",  :subject=>"Problem with spot")

  end

  def user_aquisition_query_email(start_time,end_time, who_asked)
    @start_time = start_time
    @end_time = end_time

    users = User.where("created_at >= ? and created_at <= ?", start_time,end_time)
    users.reject!{|x| x.nontrivial?}
    @user_promo = Hash.new( *users.map{|x| [x, (x.codes.count == 0)? nil : x.codes.first]}.flatten)

    mail(:to =>who_asked,  :subject=>"User Aquisition Query")

  end

end
