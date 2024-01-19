# frozen_string_literal: true

class CreatePartners < ActiveRecord::Migration[5.2]
  def change
    create_table :partners do |t|
      t.string :name, unique: true
    end
  end
end
