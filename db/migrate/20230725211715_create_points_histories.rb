class CreatePointsHistories < ActiveRecord::Migration[5.2]
  def change
    create_view :points_histories
  end
end
