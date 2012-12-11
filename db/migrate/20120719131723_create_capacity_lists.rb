class CreateCapacityLists < ActiveRecord::Migration
  class CapacityList < ActiveRecord::Base
    # Dummy class
  end
  def change
    create_table :capacity_lists do |t|
      t.integer :offer_id
    
      t.timestamps
    end
  end
end
