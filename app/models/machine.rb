# == Schema Information
#
# Table name: machines
#
#  id           :bigint           not null, primary key
#  points       :integer          default(0)
#  secret       :string           not null
#  service_type :integer          not null
#  uuid         :uuid             not null
#  partner_id   :bigint           not null
#
# Indexes
#
#  index_machines_on_partner_id  (partner_id)
#
class Machine < ApplicationRecord
  validates :secret, :service_type, presence: true
  has_many :travel_sessions
  has_many :purchases
  belongs_to :partner

  enum service_type: {
    travel: 0,
    purchase: 1
  }
end
