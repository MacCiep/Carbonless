# frozen_string_literal: true

class AdjustTravelSessionTable < ActiveRecord::Migration[5.2]
  def change
    remove_column :travel_sessions, :billet_id

    change_column :travel_sessions, :start_latitude, :string
    change_column :travel_sessions, :start_longitude, :string
    change_column :travel_sessions, :end_latitude, :string
    change_column :travel_sessions, :end_longitude, :string
  end
end
