# frozen_string_literal: true

class CreatePurchases < ActiveRecord::Migration[5.2]
  def change
    create_table :purchases do |t|
      t.references :machine, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :points, null: false, default: 0
      t.integer :purchase_type, null: false, default: 1
      t.timestamps
    end
  end
end
