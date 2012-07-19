class CreateAcceptances < ActiveRecord::Migration
  def change
    create_table :acceptances do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.float :count, :default => 0
      t.string :status, :default => "pre_pending"
      t.integer :buyer_id
      t.integer :offer_id

      t.timestamps
    end
  end
end
