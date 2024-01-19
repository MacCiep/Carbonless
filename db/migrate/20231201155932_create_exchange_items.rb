# frozen_string_literal: true

class CreateExchangeItems < ActiveRecord::Migration[7.1]
  def change
    create_table :exchange_items do |t|
      t.string :name, null: false, limit: 80
      t.string :description, limit: 300
      t.belongs_to :user, null: false, foreign_key: true
      t.integer :status, default: 0
      t.timestamps
    end
  end
end
