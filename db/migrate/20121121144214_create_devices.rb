class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :device_uid,      :default => "",     :null => false
      t.string :push_token_id,   :default => "",     :null => false
      t.string :device_type,     :default => "",     :null => false
      t.datetime :last_used_at,                      :null => false

      t.timestamps
    end
  end
end
