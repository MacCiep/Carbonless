# frozen_string_literal: true

class AddPointsToMachines < ActiveRecord::Migration[5.2]
  def change
    add_column :machines, :points, :integer, default: 0
  end
end
