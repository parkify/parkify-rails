class FixColumnName < ActiveRecord::Migration
  def change
    rename_column :promos, :type, :promo_type
  end
end
