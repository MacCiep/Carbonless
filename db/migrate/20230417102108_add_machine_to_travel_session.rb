# frozen_string_literal: true

class AddMachineToTravelSession < ActiveRecord::Migration[5.2]
  def change
    add_column :travel_sessions, :machine_id, :bigint, foreign_key: true
  end
end
