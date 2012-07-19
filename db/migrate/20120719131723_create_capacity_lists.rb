class CreateCapacityLists < ActiveRecord::Migration
  def change
    create_table :capacity_lists do |t|
      t.integer :offer_id
    
      t.timestamps
    end
  end
end
