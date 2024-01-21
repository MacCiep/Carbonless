# frozen_string_literal: true

class AddResponseDescriptionToExchangeOffers < ActiveRecord::Migration[7.1]
  def change
    add_column :exchange_offers, :response_description, :string
  end
end
