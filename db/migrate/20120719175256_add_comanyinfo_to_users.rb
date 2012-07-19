class AddComanyinfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :company_name, :string
    add_column :users, :billing_address, :text
    add_column :users, :company_phone_number, :string
  end
end
