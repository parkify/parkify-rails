class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|
      t.float :capacity, :default => 0
      t.datetime :start_time
      t.datetime :end_time
      t.integer :resource_id

      t.timestamps
    end
  end
end
