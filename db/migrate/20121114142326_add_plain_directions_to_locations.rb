class AddPlainDirectionsToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :plain_directions, :text
  end
end
