# frozen_string_literal: true

class AddSuccessFieldToTravelSession < ActiveRecord::Migration[5.2]
  def change
    add_column :travel_sessions, :success, :boolean, default: false
  end
end
