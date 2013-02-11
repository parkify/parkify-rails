class AddDelayedPaymentToAcceptances < ActiveRecord::Migration
  def change
    add_column :acceptances, :needs_payment, :float
    add_column :acceptances, :pay_by, :float
  end
end
