class CreatePricePlans < ActiveRecord::Migration
  def change
    create_table :price_plans do |t|
      t.float :price_per_hour

      t.references :price_planable, :polymorphic => true
      
      t.timestamps
    end
  end
end
