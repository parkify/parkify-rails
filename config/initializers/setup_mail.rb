ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => 'parkify.me',
  :user_name            => 'support@parkify.me',
  :password             => 'JustKidding',
  :authentication       => 'plain',
  :enable_starttls_auto => true  
}