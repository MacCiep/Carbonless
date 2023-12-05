# == Schema Information
#
# Table name: exchange_items
#
#  id          :bigint           not null, primary key
#  description :string(300)
#  name        :string(80)       not null
#  status      :integer          default("inactive")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_exchange_items_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class ExchangeItem < ApplicationRecord
  include AASM

  belongs_to :user
  validates :name, :description, :status, presence: true
  validates :name, length: { maximum: 80 }
  validates :description, length: { maximum: 300 }

  enum status: { inactive: 0, active: 1, cancelled: 2, exchanged: 3 }, _prefix: :status

  aasm column: :status, whiny_transitions: false do
    state :inactive, initial: true
    state :active, :cancelled, :exchanged

    event :activate do
      transitions from: :inactive, to: :active
    end

    event :inactivate do
      transitions from: :active, to: :inactive
    end

    event :exchange do
      transitions from: :active, to: :exchanged
    end

    event :cancel do
      transitions from: [:inactive, :active], to: :cancelled
    end
  end
end
