class CreateLocations < ActiveRecord::Migration
  class Location < ActiveRecord::Base
    # Dummy class
  end
  def change
    create_table :locations do |t|
      t.float :latitude
      t.float :longitude
      t.text :location_name, :default => "", :null => false
      t.text :directions, :default => "", :null => false
      t.text :location_address
      
      t.references :locationable, :polymorphic => true

      t.timestamps
    end
  end
end
