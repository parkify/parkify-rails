class CreateOfferScheduleExceptions < ActiveRecord::Migration
  def change
    create_table :offer_schedule_exceptions do |t|
      t.integer :resource_offer_id
      t.string :exception_type,      :default => "modify", :null => false
      t.float :start,                :default => 0, :null => false
      t.float :duration,             :default => 0, :null => false
      t.float :price,                :default => 1, :null => false
      t.float :capacity,             :default => 1, :null => false

      t.timestamps
    end
  end
end
