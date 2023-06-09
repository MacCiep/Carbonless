class CreateUsersPrizes < ActiveRecord::Migration[5.2]
  def change
    create_table :users_prizes, id: :uuid do |t|
      t.belongs_to :user
      t.belongs_to :prize
      t.integer :duration_left, null: false
    end
  end
end
