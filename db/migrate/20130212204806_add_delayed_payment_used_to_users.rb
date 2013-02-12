class AddDelayedPaymentUsedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :delayed_payment_used, :boolean, :default=>false
  end
end
