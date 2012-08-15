class CreateAgreements < ActiveRecord::Migration
  def change
    create_table :agreements do |t|
      t.integer :offer_id
      t.integer :acceptance_id

      t.timestamps
    end
  end
end
