class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|
      t.references :machine, null: false, foreign_key: true
      t.numeric :latitude, null: false
      t.numeric :longitude, null: false
    end
  end
end
