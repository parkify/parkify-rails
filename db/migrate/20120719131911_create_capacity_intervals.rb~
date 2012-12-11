class CreateCapacityIntervals < ActiveRecord::Migration
  def change
    create_table :capacity_intervals do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.float :capacity, :default => 0
      t.integer :capacity_list_id

      t.timestamps
    end
  end
end
