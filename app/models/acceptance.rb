class Acceptance < ActiveRecord::Base
  attr_accessible :user_id, :count, :end_time, :offer_id, :start_time, :status
  
  belongs_to :offer
  belongs_to :user
  
  has_one :payment_info
  
  
end
