class CreateOfferSchedules < ActiveRecord::Migration
  def change
    create_table :offer_schedules do |t|
      t.integer :resource_offer_id
      t.datetime :start_date,        :default => nil
      t.datetime :end_date,          :default => nil
      t.string :recurrance_type,     :default => "None", :null => false
      t.float :relative_start,       :default => 0,      :null => false
      t.float :duration,             :default => 0, :null => false
      t.float :price_per_hour,       :default => 1, :null => false
      t.float :capacity,             :default => 1, :null => false

      t.timestamps
    end
  end
end
