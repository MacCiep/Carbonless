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

    context '#offer_for_own_item?' do
      let(:user) { create(:user) }
      let(:exchange_item) { create(:exchange_item, user:) }
      let(:exchange_offer) { build(:exchange_offer, user: user, exchange_item: exchange_item) }

      it 'adds error when user is trying to offer his own item' do
        exchange_offer.valid?
        expect(exchange_offer.errors[:exchange_item]).to include("can't create offer for your own item")
      end
    end
  end

  describe 'enums' do
    it { should define_enum_for(:status).with_values(pending: 0, rejected: 1, accepted: 2, completed: 3).with_prefix(:status) }
  end

  describe 'aasm' do
    let(:record) { create(:exchange_offer, status:) }

    context 'when status is pending' do
      let(:status) { 'pending' }

      it_behaves_like 'allows for transition to', :accepted
      it_behaves_like 'allows for transition to', :rejected

      it_behaves_like 'does not allow for transition to', :pending
      it_behaves_like 'does not allow for transition to', :completed

      it_behaves_like 'with respond to event', :accept
      it_behaves_like 'with respond to event', :reject
    end

    context 'when status is accepted' do
      let(:status) { 'accepted' }

      it_behaves_like 'allows for transition to', :completed

      it_behaves_like 'does not allow for transition to', :accepted

      it_behaves_like 'with respond to event', :complete
    end

    context 'when status is rejected' do
      let(:status) { 'rejected' }

      it_behaves_like 'does not allow for transition to', :accepted
      it_behaves_like 'does not allow for transition to', :rejected
      it_behaves_like 'does not allow for transition to', :pending
      it_behaves_like 'does not allow for transition to', :completed
    end

    context 'when status is completed' do
      let(:status) { 'completed' }

      it_behaves_like 'does not allow for transition to', :accepted
      it_behaves_like 'does not allow for transition to', :rejected
      it_behaves_like 'does not allow for transition to', :pending
      it_behaves_like 'does not allow for transition to', :completed
    end
  end
end
