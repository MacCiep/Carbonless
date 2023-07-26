class ChangeDefaultValueForPrizesPrice < ActiveRecord::Migration[5.2]
  def change
    change_column_default :prizes, :price, 0
  end
end
