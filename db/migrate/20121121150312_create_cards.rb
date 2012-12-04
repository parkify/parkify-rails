class CreateCards < ActiveRecord::Migration
  def change
    rename_table :stripe_customer_ids, :cards
  end
end
