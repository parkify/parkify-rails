class UserMailer < ActionMailer::Base
  default from: "do-not-reply@parkify.me"

  def welcome_email(user)
    @user = user
    mail(:to => user.email, :subject => "Welcome to My Awesome Site")
  end
end
