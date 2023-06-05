# == Schema Information
#
# Table name: machines
#
#  id           :bigint           not null, primary key
#  points       :integer          default(0)
#  secret       :string           not null
#  service_type :integer          not null
#  uuid         :uuid             not null
#
class Machine < ApplicationRecord
  validates :secret, :service_type, presence: true
  has_many :travel_sessions
  has_many :purchases

  enum service_type: {
    travel: 0,
    cloth: 1,
    food: 2
  }
end
