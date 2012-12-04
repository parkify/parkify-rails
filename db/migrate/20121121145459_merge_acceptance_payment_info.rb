class MergeAcceptancePaymentInfo < ActiveRecord::Migration
  def change
    change_table :acceptances do |t|
      t.integer  :card_id
      t.float    :amount_charged
      t.string   :stripe_charge_id
      t.string   :details,               :default => "", :null => false
    end
  end
end
