class CreateFlatRatePrices < ActiveRecord::Migration
  def change
    create_table :flat_rate_prices do |t|
      t.float :duration,   :default => 0,     :null => false
      t.float :price,      :default => 0,     :null => false
      t.string :name,      :default => "",     :null => false
      t.timestamps
    end
  end
end
