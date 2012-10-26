class CreateCodes < ActiveRecord::Migration
  def change
    create_table :codes do |t|
      t.text :code_text
      t.boolean :personal
      t.integer :promo_id

      t.timestamps
    end
  end
end
