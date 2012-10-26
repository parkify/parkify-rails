class CreatePromoUsers < ActiveRecord::Migration
  def change
    create_table :promo_users do |t|
      t.integer :user_id
      t.integer :promo_idd
      t.integer :code_id

      t.timestamps
    end
  end
end
