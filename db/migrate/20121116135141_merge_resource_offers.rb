class MergeResourceOffers < ActiveRecord::Migration
  def change
    create_table :resource_offers do |t|
      t.text :description,   :default => "",   :null => false
      t.integer :user_id
      t.string :title
      t.boolean :active,        :default => true
      t.integer :sign_id

      t.float    :latitude
      t.float    :longitude
      t.text     :location_name,     :default => "", :null => false
      t.text     :directions,        :default => "", :null => false
      t.text     :plain_directions,  :default => "", :null => false
      t.text     :location_address,  :default => "", :null => false

      t.timestamps
    end

    change_table :quick_properties do |t|
      t.rename :resource_id, :resource_offer_id
    end

    change_table :acceptances do |t|
      t.integer :resource_offer_id
    end
  end
end
