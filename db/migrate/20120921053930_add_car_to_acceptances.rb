class AddCarToAcceptances < ActiveRecord::Migration
  def change
    add_column :acceptances, :car_id, :integer
  end
end
