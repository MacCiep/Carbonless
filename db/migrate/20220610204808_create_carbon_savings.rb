class CreateCarbonSavings < ActiveRecord::Migration[6.1]
  def change
    create_table :carbon_savings do |t|
      t.belongs_to :user, foreign_key: true, null: false, index: true
      t.integer :points, null: false
      t.timestamps
    end
  end
end
