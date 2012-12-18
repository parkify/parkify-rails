class AddResUsedToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :reservationused, :bool, :default=>false
  end
end
