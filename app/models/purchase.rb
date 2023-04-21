# == Schema Information
#
# Table name: purchases
#
#  id         :bigint           not null, primary key
#  points     :integer          default(0), not null
#  type       :string           default("0"), not null
#  machine_id :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_purchases_on_machine_id  (machine_id)
#  index_purchases_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (machine_id => machines.id)
#  fk_rails_...  (user_id => users.id)
#
class Purchase < ApplicationRecord
  validates :machine, :points, :type, :user, presence: true
  belongs_to :user
end
