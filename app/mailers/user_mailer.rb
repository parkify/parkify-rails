class UserMailer < ActionMailer::Base
  default from: "you-are-a-valued-customer@parkify.me"

  def welcome_email(user)
    @user = user
    mail(:to => user.email, :subject => "Welcome to Parkify!")
  end
end
