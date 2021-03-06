class CreateComplaints < ActiveRecord::Migration
  def change
    create_table :complaints do |t|
      t.integer :user_id
      t.integer :resource_offer_id
      t.string :description,        :default => "",    :null => false
      t.string :imageurl,        :default => "",    :null => false
      t.float :latitude
      t.float :longitude
      t.boolean :resolved,          :default => false, :null => false

      t.timestamps
    end
  end
end
