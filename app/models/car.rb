class Car < ActiveRecord::Base
  attr_accessible :details, :license_plate_number, :user_id
  
  belongs_to :user
  
end
