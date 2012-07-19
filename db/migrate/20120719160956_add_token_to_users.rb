class AddTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :authentication_token, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
  end
  #add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
end
