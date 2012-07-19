class ChangeAcceptances < ActiveRecord::Migration
  def change
    rename_column :acceptances, :buyer_id, :user_id
    rename_column :resources, :vendor_id, :user_id
  end

end
