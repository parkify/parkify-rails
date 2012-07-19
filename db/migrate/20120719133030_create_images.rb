class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :name, :default => "", :null => false
      t.string :path, :default => "", :null => false
      t.string :description, :default => "", :null => false

      t.references :imageable, :polymorphic => true
      
      t.timestamps
    end
  end
end
