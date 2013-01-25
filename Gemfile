#source 'https://rubygems.org'
source "http://bundler-api.herokuapp.com"

gem 'rails', '3.2.7rc1'

gem 'rest-client', "~>1.6.7"

gem 'fastimage'
gem 'hipchat-api'

group :development, :test do
  #gem 'sqlite3', '1.3.5'
  gem 'capybara'
  gem 'rspec-rails'
  gem 'haml-rails'
  gem 'hpricot'
  gem 'ruby_parser'
  gem "factory_girl_rails", "~> 4.0"
  gem 'heroku_san'
  #gem 'web-app-theme'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '3.2.4'
  gem 'coffee-rails', '3.2.2'

  gem 'uglifier', '1.2.3'
end

#Temporarily  removed while rubygems.coms Dependency API is down.
#gem 'jquery-rails', '2.0.0'
gem 'newrelic_rpm'
gem 'devise'
gem 'cancan'
gem 'haml'
#gem 'stripe', :git => 'https://github.com/stripe/stripe-ruby'
gem 'stripe'
gem 'xml-simple'

gem "paperclip", "~> 3.0"
gem 'rails_admin'
gem 'resque'
gem 'ohm'

gem 'pg', '0.12.2'

gem 'nokogiri'

group :production do
  #gem 'pg', '0.12.2'
  gem "rmagick", "2.12.0", :require => 'RMagick'
  gem 'aws-s3'
  gem 'aws-sdk'
end
