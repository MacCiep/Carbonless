# == Schema Information
#
# Table name: machines
#
#  id           :bigint           not null, primary key
#  secret       :string           not null
#  service_type :integer          not null
#  uuid         :string           not null
#
class Machine < ApplicationRecord
  validates :uuid, :secret, :service_type, presence: true
  enum service_type: {
    travel: 0,
    clothes: 1,
    food: 2
  }
end
