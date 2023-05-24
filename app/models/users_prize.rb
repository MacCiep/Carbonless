# == Schema Information
#
# Table name: users_prizes
#
#  id         :bigint           not null, primary key
#  active     :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  prize_id   :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_users_prizes_on_prize_id  (prize_id)
#  index_users_prizes_on_user_id   (user_id)
#
class UsersPrize < ApplicationRecord
  belongs_to :prize
  belongs_to :user

  delegate :duration, to: :prize
end
