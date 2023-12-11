# == Schema Information
#
# Table name: exchange_offers
#
#  id                   :bigint           not null, primary key
#  description          :text             not null
#  response_description :string
#  status               :integer          default("pending"), not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  exchange_item_id     :bigint           not null
#  user_id              :bigint           not null
#
# Indexes
#
#  index_exchange_offers_on_exchange_item_id  (exchange_item_id)
#  index_exchange_offers_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (exchange_item_id => exchange_items.id)
#  fk_rails_...  (user_id => users.id)
#
class ExchangeOffer < ApplicationRecord
  include AASM

  belongs_to :user
  belongs_to :exchange_item

  validates :user, :exchange_item, :description, :status, presence: true
  validates :description, length: { maximum: 250 }
  validate :offer_for_own_item?
  validate :response_with_description?, if: :status_rejected? || :status_accepted?

  enum status: { pending: 0, rejected: 1, accepted: 2, completed: 3 }, _prefix: :status

  aasm column: :status, whiny_transitions: false do
    state :pending, initial: true
    state :rejected, :accepted, :completed

    event :accept do
      transitions from: :pending, to: :accepted
    end

    event :reject do
      transitions from: :pending, to: :rejected
    end

    event :complete do
      transitions from: :accepted, to: :completed
    end
  end

  private

  def offer_for_own_item?
    return unless exchange_item&.user_id == user_id

    errors.add(:exchange_item, "can't create offer for your own item")
  end

  def response_with_description?
    response_description.present?
  end
end
