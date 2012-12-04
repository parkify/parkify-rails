class AddNotificationSettingsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sms_notification, :boolean,   :default => true, :null => false 
    add_column :users, :email_notification, :boolean, :default => true, :null => false
    add_column :users, :push_notification, :boolean,  :default => true, :null => false
  end
end
