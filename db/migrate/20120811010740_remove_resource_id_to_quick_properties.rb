class RemoveResourceIdToQuickProperties < ActiveRecord::Migration
  def up
    remove_column :quick_properties, :resource_id
  end

  def down
    add_column :quick_properties, :resource_id, :string
  end
end
