class AddResourceIdToQuickProperties < ActiveRecord::Migration
  def change
    add_column :quick_properties, :resource_id, :string
  end
end
