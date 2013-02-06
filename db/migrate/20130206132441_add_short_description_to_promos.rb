class AddShortDescriptionToPromos < ActiveRecord::Migration
  def change
    add_column :promos, :short_description, :string
  end
end
