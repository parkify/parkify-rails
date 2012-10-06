class AddActiveToResources < ActiveRecord::Migration
  def change
    add_column :resources, :active, :boolean, :default => true
  end
end
