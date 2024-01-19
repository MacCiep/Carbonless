# frozen_string_literal: true

class AddCountryAndCityColumnsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :country, :string
    add_column :users, :city, :string
  end
end
