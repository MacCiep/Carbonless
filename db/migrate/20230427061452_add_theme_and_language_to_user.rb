# frozen_string_literal: true

class AddThemeAndLanguageToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :theme, :integer, default: 0, null: false
    add_column :users, :language, :integer, default: 0, null: false
  end
end
