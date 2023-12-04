# == Schema Information
#
# Table name: exchange_offers
#
#  id               :bigint           not null, primary key
#  description      :text             not null
#  status           :integer          default("pending"), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  exchange_item_id :bigint           not null
#  user_id          :bigint           not null
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
require 'rails_helper'

RSpec.describe ExchangeOffer, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:exchange_item) }
  end

  describe 'validations' do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:exchange_item) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:status) }
    it { should validate_length_of(:description).is_at_most(250) }
  end

  describe 'enums' do
    it { should define_enum_for(:status).with_values(pending: 0, rejected: 1, accepted: 2, completed: 3) }
  end

end
