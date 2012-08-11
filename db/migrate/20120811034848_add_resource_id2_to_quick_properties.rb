class AddResourceId2ToQuickProperties < ActiveRecord::Migration
  def change
    add_column :quick_properties, :resource_id, :integer
  end
end
