class ImproveTravelSessionTable < ActiveRecord::Migration[5.2]
  def change
    remove_column :travel_sessions, :travel_tool
    remove_column :travel_sessions, :start_station
    remove_column :travel_sessions, :end_station

    add_column :travel_sessions, :billet_id, :string

    add_column :travel_sessions, :start_longitude, :numeric
    add_column :travel_sessions, :start_latitude, :numeric

    add_column :travel_sessions, :end_longitude, :numeric
    add_column :travel_sessions, :end_latitude, :numeric

    add_column :travel_sessions, :car_distance, :numeric

    add_column :travel_sessions, :active, :boolean
  end
end
