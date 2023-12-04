class ExchangeItem < ApplicationRecord
  belongs_to :user
  validates :name, :description, :status, presence: true
  enum status: { inactive: 0, active: 1, cancelled: 2, exchanged: 3 }
end
