class AddActiveColumnToUsersPrizes < ActiveRecord::Migration[5.2]
  def change
    add_column :users_prizes, :active, :boolean, default: true, nil: false
  end
end
