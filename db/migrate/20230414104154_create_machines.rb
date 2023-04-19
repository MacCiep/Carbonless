class CreateMachines < ActiveRecord::Migration[5.2]
  def change
    create_table :machines do |t|
      t.string :uuid, null: false
      t.string :secret, null: false
      t.integer :service_type, null: false
    end
  end
end
