class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.text :description, :default => "", :null => false
      t.integer :location_id
      t.float :capacity, :default => 0
      t.integer :price_plan_id
      t.integer :vendor_id

      t.timestamps
    end
  end
end
