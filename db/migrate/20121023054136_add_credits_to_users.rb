class AddCreditsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :credit, :float, :default => 0.0
  end
end
