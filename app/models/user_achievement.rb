# # == Schema Information
# #
# # Table name: user_achievements
# #
# #  id             :bigint           not null, primary key
# #  counter        :integer          default(0), not null
# #  achievement_id :bigint           not null
# #  user_id        :bigint           not null
# #
# # Indexes
# #
# #  index_user_achievements_on_achievement_id  (achievement_id)
# #  index_user_achievements_on_user_id         (user_id)
# #
# class UserAchievement < ApplicationRecord
#   belongs_to :user
#   belongs_to :achievement
#
#   validates_presence_of :user, :achievement
# end
