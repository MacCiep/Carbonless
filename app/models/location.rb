# frozen_string_literal: true

# == Schema Information
#
# Table name: locations
#
#  id         :bigint           not null, primary key
#  city       :string
#  country    :string
#  latitude   :decimal(, )      not null
#  longitude  :decimal(, )      not null
#  machine_id :bigint           not null
#
# Indexes
#
#  index_locations_on_machine_id  (machine_id)
#
# Foreign Keys
#
#  fk_rails_...  (machine_id => machines.id)
#

class Location < ApplicationRecord
  belongs_to :machine
  has_one :partner, through: :machine

  validates :latitude, :longitude, presence: true
  # validates :latitude, format: { with: /\A[+-]?((9[0]?|[0-8][0-9]?([.,][0-9]+)?))\z/ }
  # validates :longitude, format: { with: /\A[+-]?((9[0]?|[0-8][0-9]?([.,][0-9]+)?))\z/ }

  scope :with_nearby_machines, lambda { |latitude, longitude, range = 10|
    radius = KM_TO_DEGREES * range
    where("latitude >= #{latitude - radius} AND latitude <= #{latitude + radius}
            AND longitude >= #{longitude - radius} AND longitude <= #{longitude + radius}")
  }

  KM_TO_DEGREES = 0.00901
end
