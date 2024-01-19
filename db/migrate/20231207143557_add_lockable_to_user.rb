# frozen_string_literal: true

class AddLockableToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :flagged_messages, :integer, default: 0, null: false
    add_column :users, :unlock_token, :string
    add_column :users, :locked_at, :datetime
  end
end
