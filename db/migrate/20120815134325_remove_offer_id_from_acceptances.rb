class RemoveOfferIdFromAcceptances < ActiveRecord::Migration
  def up
    remove_column :acceptances, :offer_id
  end

  def down
    add_column :acceptances, :offer_id
  end
end
