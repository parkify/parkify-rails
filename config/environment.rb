# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
ParkifyRails::Application.initialize!

#Specify the encoding
Encoding.default_external = "UTF-8"