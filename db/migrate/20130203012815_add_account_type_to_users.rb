class AddAccountTypeToUsers < ActiveRecord::Migration

  class User < ActiveRecord::Base
  end

  def change
    add_column :users, :account_type, :string, :null => "false", :default => "standard"
  end
end
