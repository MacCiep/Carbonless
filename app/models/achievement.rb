# == Schema Information
#
# Table name: achievements
#
#  id            :bigint           not null, primary key
#  points        :integer
#  scope_of_days :integer
#  script        :string           not null
#  title         :string           not null
#  type          :integer
#
class Achievement < ApplicationRecord
  has_many :users, through: :user_achievements

  validates_presence_of :title

  enum type: {
    carbon: 0,
    travel: 1,
    longest_route: 2
  }
end
