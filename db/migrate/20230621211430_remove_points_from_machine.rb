class RemovePointsFromMachine < ActiveRecord::Migration[5.2]
  def change
    remove_column :machines, :points
  end
end
