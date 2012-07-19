class AddActivecarToCars < ActiveRecord::Migration
  def change
    add_column :cars, :active_car, :boolean
  end
end
