class Acceptance < ActiveRecord::Base
  attr_accessible :buyer_id, :count, :end_time, :offer_id, :start_time, :status
  
  belongs_to :offer
  belongs_to :user, :foreign_key => :buyer_id
  
  has_one :payment_info
  
  
end
