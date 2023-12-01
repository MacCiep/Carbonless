# == Schema Information
#
# Table name: machines
#
#  id           :bigint           not null, primary key
#  secret       :string           not null
#  service_type :integer          not null
#  uuid         :uuid             not null
#  partner_id   :bigint           not null
#  user_id      :bigint
#
# Indexes
#
#  index_machines_on_partner_id  (partner_id)
#  index_machines_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (partner_id => partners.id)
#
class Machine < ApplicationRecord
  validates :secret, :service_type, presence: true
  has_many :travel_sessions
  has_many :purchases
  has_one :location
  belongs_to :partner
  belongs_to :user, optional: true

  delegate :points, to: :partner

  enum service_type: {
    travel: 0,
    purchase: 1
  }
end
