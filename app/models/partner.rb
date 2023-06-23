# == Schema Information
#
# Table name: partners
#
#  id     :bigint           not null, primary key
#  name   :string
#  points :integer          default(0), not null
#
class Partner < ApplicationRecord
  has_many :prize
  has_many :machines
  has_many :locations, through: :machines
  has_one_attached :logo

  scope :with_nearby_locations, -> (latitude, longitude) {
    where("latitude >= #{latitude - 0.1} AND latitude <= #{latitude + 0.1}
            AND longitude >= #{longitude - 0.1} AND longitude <= #{longitude + 0.1}")
  }
end
