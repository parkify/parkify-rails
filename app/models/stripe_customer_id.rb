class StripeCustomerId < ActiveRecord::Base
  attr_accessible :active_customer, :customer_id, :user_id, :last4
    belongs_to :user
    has_many :payment_infos
    
  def as_json(options={})
    result = super(:only => [:id, :last4])
    result["active"] = self.active_customer
    result
    
  end
end
