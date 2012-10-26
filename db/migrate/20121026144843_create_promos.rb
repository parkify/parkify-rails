class CreatePromos < ActiveRecord::Migration
  def change
    create_table :promos do |t|
      t.text :name
      t.text :description
      t.text :promo_type
      t.datetime :start_time
      t.datetime :end_time
      t.float :value1
      t.float :value2

      t.timestamps
    end
  end
end
