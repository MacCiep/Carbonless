# frozen_string_literal: true

class AddCountryAndCityColumnsToLocation < ActiveRecord::Migration[5.2]
  def change
    add_column :locations, :country, :string, null: nil
    add_column :locations, :city, :string, null: nil
  end
end
