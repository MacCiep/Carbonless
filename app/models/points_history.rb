# == Schema Information
#
# Table name: points_histories
#
#  history_type :text
#  partner_name :string
#  points       :integer
#  prize_title  :text
#  created_at   :datetime
#  user_id      :bigint
#
class PointsHistory < ApplicationRecord
  def readonly?
    true
  end
end
