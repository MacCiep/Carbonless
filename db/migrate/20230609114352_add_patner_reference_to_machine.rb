# frozen_string_literal: true

class AddPatnerReferenceToMachine < ActiveRecord::Migration[5.2]
  def change
    add_reference :machines, :partner, null: false, foreign_key: true
  end
end
