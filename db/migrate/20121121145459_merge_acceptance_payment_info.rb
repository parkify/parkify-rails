class MergeAcceptancePaymentInfo < ActiveRecord::Migration

  def up
    change_table :acceptances do |t|
      t.integer  :card_id
      t.float    :amount_charged
      t.string   :stripe_charge_id
      t.string   :details,               :default => "", :null => false
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end


def updateAcceptances()
    
    Acceptance.reset_column_information
    PaymentInfo.reset_column_information


    Acceptance.all.each do |a|
     result = ActiveRecord::Base.connection.select_all("SELECT * FROM payment_infos where acceptance_id = #{a.id}").each do |pInfo| 
#PaymentInfo.joins(",acceptances").where("payment_infos.acceptance_id = acceptances.id AND acceptances.id = ?", a.id).each do |pInfo|
        a.card_id = pInfo["stripe_customer_id_id"]
        a.stripe_charge_id = pInfo["stripe_charge_id"]
        a.details = pInfo["details"]
        a.amount_charged = pInfo["amount_charged"]
      end         
      a.save
    end
  end

end
