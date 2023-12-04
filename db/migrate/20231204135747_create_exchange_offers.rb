class CreateExchangeOffers < ActiveRecord::Migration[7.1]
  def change
    create_table :exchange_offers do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :exchange_item, null: false, foreign_key: true
      t.text :description, null: false, limit: 250
      t.integer :status, null: false, default: 0
      t.timestamps
    end
  end
end
