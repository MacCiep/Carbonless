class RemoveDurationColumnFromPrizes < ActiveRecord::Migration[5.2]
  def change
    remove_column :users_prizes, :duration
  end
end
