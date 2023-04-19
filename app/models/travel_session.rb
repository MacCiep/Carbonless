# == Schema Information
#
# Table name: travel_sessions
#
#  id              :bigint           not null, primary key
#  active          :boolean
#  car_distance    :decimal(, )
#  end_latitude    :string
#  end_longitude   :string
#  start_latitude  :string
#  start_longitude :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  machine_id      :bigint
#  user_id         :bigint
#
# Indexes
#
#  index_travel_sessions_on_user_id  (user_id)
#
class TravelSession < ApplicationRecord
  belongs_to :user
  belongs_to :machine

  scope :active, -> { where(active: true) }
end
