class CreatePaymentInfos < ActiveRecord::Migration
  def change
    create_table :payment_infos do |t|
      t.string :stripe_customer_id_id
      t.integer :acceptance_id
      t.float :amount_charged
      t.string :stripe_charge_id

      t.timestamps
    end
  end
end
