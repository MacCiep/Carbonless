# == Schema Information
#
# Table name: locations
#
#  id         :bigint           not null, primary key
#  latitude   :decimal(, )      not null
#  longitude  :decimal(, )      not null
#  machine_id :bigint           not null
#
# Indexes
#
#  index_locations_on_machine_id  (machine_id)
#
class Location < ApplicationRecord
  belongs_to :machine
  has_one :partner, through: :machine
  validates_presence_of :machine, :latitude, :longitude

  validates :latitude, format: { with: /\A[+-]?((9[0]?|[0-8][0-9]?([.,][0-9]+)?))\z/ }
  validates :longitude, format: { with: /\A[+-]?((9[0]?|[0-8][0-9]?([.,][0-9]+)?))\z/ }

  scope :with_nearby_machines, -> (latitude, longitude) {
    where("latitude >= #{latitude - 0.1} AND latitude <= #{latitude + 0.1}
            AND longitude >= #{longitude - 0.1} AND longitude <= #{longitude + 0.1}")
  }
end
