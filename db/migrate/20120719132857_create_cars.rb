class CreateCars < ActiveRecord::Migration
  def change
    create_table :cars do |t|
      t.text :details, :default => "", :null => false
      t.string :license_plate_number, :default => "", :null => false
      t.integer :user_id

      t.timestamps
    end
  end
end
