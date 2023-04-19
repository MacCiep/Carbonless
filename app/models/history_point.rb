# == Schema Information
#
# Table name: history_points
#
#  id             :bigint           not null, primary key
#  category       :integer
#  end_station    :integer
#  history_type   :integer
#  points         :bigint           not null
#  purchase_price :integer
#  start_datetime :datetime
#  start_station  :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :bigint
#
# Indexes
#
#  index_history_points_on_user_id  (user_id)
#
class HistoryPoint < ApplicationRecord
  belongs_to :user

  enum history_type: {
    'travel': 0,
    'purchase': 1
  }

  enum category: {
    'bus': 0,
    'train': 1,
    'bike': 2,
    'tram': 3,
    'metro': 4,
    'food': 5,
    'clothes': 6
  }

  validates :history_type, :category, presence: true
end
