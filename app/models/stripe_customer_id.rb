class StripeCustomerId < ActiveRecord::Base
  attr_accessible :active_customer, :customer_id, :user_id
    belongs_to :user
    has_many :payment_infos
end
