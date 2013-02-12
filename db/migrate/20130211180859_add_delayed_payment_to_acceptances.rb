class AddDelayedPaymentToAcceptances < ActiveRecord::Migration
  def change
    add_column :acceptances, :needs_payment, :float, :default=>0
    add_column :acceptances, :pay_by, :float, :default=>0
  end
end
