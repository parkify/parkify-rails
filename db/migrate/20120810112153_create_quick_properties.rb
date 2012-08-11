class CreateQuickProperties < ActiveRecord::Migration
  def change
    create_table :quick_properties do |t|
      t.string :key
      t.string :value

      t.timestamps
    end
  end
end
