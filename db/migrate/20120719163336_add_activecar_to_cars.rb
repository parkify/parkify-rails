class AddActivecarToCars < ActiveRecord::Migration
  def change
    add_column :cars, :active_car, :boolean, :default => "", :null => false
  end
end
