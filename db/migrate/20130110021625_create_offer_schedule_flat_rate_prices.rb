class CreateOfferScheduleFlatRatePrices < ActiveRecord::Migration
  def change
    create_table :offer_schedule_flat_rate_prices do |t|
      t.timestamps
      t.references :offer_schedule_flat_rate_priceable, :polymorphic => true
      t.string :flat_rate_price_id
    end
  end
end
