class RenameDurationLeftToDuration < ActiveRecord::Migration[5.2]
  def change
    rename_column :users_prizes, :duration_left, :duration
  end
end
