class AddDetailsToPaymentInfo < ActiveRecord::Migration
  def change
    add_column :payment_infos, :details, :string, :default => ""
  end
end
