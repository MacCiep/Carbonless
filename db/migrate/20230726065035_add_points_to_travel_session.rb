# frozen_string_literal: true

class AddPointsToTravelSession < ActiveRecord::Migration[5.2]
  def change
    add_column :travel_sessions, :points, :integer, default: 0, null: false
  end
end
