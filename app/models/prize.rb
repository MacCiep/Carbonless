# == Schema Information
#
# Table name: prizes
#
#  id         :bigint           not null, primary key
#  duration   :integer          not null
#  price      :integer          default(0), not null
#  title      :string           not null
#  uuid       :uuid             not null
#  partner_id :bigint
#
# Indexes
#
#  index_prizes_on_partner_id  (partner_id)
#
# Foreign Keys
#
#  fk_rails_...  (partner_id => partners.id)
#
class Prize < ApplicationRecord
  validates :duration, :price, :title, presence: true
  validates :duration, :price, numericality: { greater_than: 0 }

  belongs_to :partner
  has_many :users_prizes
end
