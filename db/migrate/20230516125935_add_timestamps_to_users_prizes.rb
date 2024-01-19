# frozen_string_literal: true

class AddTimestampsToUsersPrizes < ActiveRecord::Migration[5.2]
  def change
    add_column :users_prizes, :created_at, :datetime, null: false
    add_column :users_prizes, :updated_at, :datetime, null: false
  end
end
