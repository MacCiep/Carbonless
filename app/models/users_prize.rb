# == Schema Information
#
# Table name: users_prizes
#
#  id            :bigint           not null, primary key
#  duration_left :integer          not null
#  prize_id      :bigint
#  user_id       :bigint
#
# Indexes
#
#  index_users_prizes_on_prize_id  (prize_id)
#  index_users_prizes_on_user_id   (user_id)
#
class UsersPrize < ApplicationRecord
  belongs_to :prize
  belongs_to :user
end
