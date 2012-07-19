class CreateStripeCustomerIds < ActiveRecord::Migration
  def change
    create_table :stripe_customer_ids do |t|
      t.string :customer_id
      t.integer :user_id
      t.boolean :active_customer, :default => false, :null => false

      t.timestamps
    end
  end
end
