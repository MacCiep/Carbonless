# frozen_string_literal: true

class FixUsersTable < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :tgtg_active
    remove_column :users, :name
    remove_column :users, :lastname
    add_column :users, :username, :string, max: 30
  end
end
