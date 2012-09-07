ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => 'parkify.me',
  :user_name            => 'you-are-a-valued-customer@parkify.me',
  :password             => 'JustKidding',
  :authentication       => 'plain',
  :enable_starttls_auto => true  
}
  