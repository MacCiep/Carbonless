class FixPurchasesTable < ActiveRecord::Migration[5.2]
  def change
    remove_column :purchases, :points
    remove_column :purchases, :purchase_type
  end
end
