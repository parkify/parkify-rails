class Card < ActiveRecord::Base
  attr_accessible :active_customer, :customer_id, :last4, :user_id, :zip_code

    belongs_to :user
    has_many :acceptance

  def as_json(options={})
    result = super(:only => [:id, :last4])
    result["active"] = self.active_customer
    result
  end
end
