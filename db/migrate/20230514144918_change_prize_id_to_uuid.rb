# frozen_string_literal: true

class ChangePrizeIdToUuid < ActiveRecord::Migration[5.2]
  def change
    add_column :prizes, :uuid, :uuid, default: 'gen_random_uuid()', null: false
  end
end
