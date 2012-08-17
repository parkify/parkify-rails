class CreatePriceIntervals < ActiveRecord::Migration
  def change
    create_table :price_intervals do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.float :price_per_hour
      t.integer :price_plan_id

      t.timestamps
    end
  end
end
