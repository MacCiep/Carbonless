# frozen_string_literal: true

class AddPointsToPartner < ActiveRecord::Migration[5.2]
  def change
    add_column :partners, :points, :integer, default: 0, null: false
  end
end
