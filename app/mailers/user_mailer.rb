class UserMailer < ActionMailer::Base
  default from: "dylan.r.jackson@gmail.com"

  def welcome_email(user)
    @user = user
    mail(:to => user.email, :subject => "Welcome to My Awesome Site")
  end
end
