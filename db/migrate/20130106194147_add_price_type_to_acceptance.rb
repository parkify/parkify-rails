class AddPriceTypeToAcceptance < ActiveRecord::Migration
  def change
    add_column :acceptances, :price_type, :string, :default => "", :null => false
  end
end
