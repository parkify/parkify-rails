class AddLast4ToStripeCustomerIds < ActiveRecord::Migration
  def change
    add_column :stripe_customer_ids, :last4, :text, :default => ""
  end
end
