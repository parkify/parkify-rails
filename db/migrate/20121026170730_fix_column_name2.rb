class FixColumnName2 < ActiveRecord::Migration
  def change
    rename_column :promo_users, :promo_idd, :promo_id
  end
end
