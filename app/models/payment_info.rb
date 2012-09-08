class PaymentInfo < ActiveRecord::Base
  attr_accessible :acceptance_id, :amount_charged, :stripe_charge_id, :stripe_customer_id_id
  
  belongs_to :acceptance
  belongs_to :stripe_customer_id
  
  def card
    ch = Stripe::Charge.retrieve(self.stripe_charge_id)
    return ch.card
  end
end
