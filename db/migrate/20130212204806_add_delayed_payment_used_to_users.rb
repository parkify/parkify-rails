class AddDelayedPaymentUsedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :delayed_payement_used, :boolean, :default=>false
  end
end
