# frozen_string_literal: true

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
require 'rails_helper'

RSpec.describe ExchangeItem do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user).with_message('must exist') }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_length_of(:name).is_at_most(80) }
    it { is_expected.to validate_length_of(:description).is_at_most(300) }
  end

  describe 'enums' do
    it {
      expect(subject).to define_enum_for(:status).with_values(inactive: 0, active: 1, cancelled: 2,
                                                              exchanged: 3).with_prefix(:status)
    }
  end

  describe 'aasm' do
    let(:record) { create(:exchange_item, status:) }

    context 'when status is inactive' do
      let(:status) { 'inactive' }

      it_behaves_like 'allows for transition to', :active
      it_behaves_like 'allows for transition to', :cancelled

      it_behaves_like 'does not allow for transition to', :inactive
      it_behaves_like 'does not allow for transition to', :exchanged

      it_behaves_like 'with respond to event', :activate
      it_behaves_like 'with respond to event', :cancel
    end

    context 'when status is active' do
      let(:status) { 'active' }

      it_behaves_like 'allows for transition to', :inactive
      it_behaves_like 'allows for transition to', :exchanged
      it_behaves_like 'allows for transition to', :cancelled

      it_behaves_like 'does not allow for transition to', :active

      it_behaves_like 'with respond to event', :exchange
      it_behaves_like 'with respond to event', :inactivate
    end

    context 'when status is cancelled' do
      let(:status) { 'cancelled' }

      it_behaves_like 'does not allow for transition to', :active
      it_behaves_like 'does not allow for transition to', :cancelled
      it_behaves_like 'does not allow for transition to', :inactive
      it_behaves_like 'does not allow for transition to', :exchanged
    end

    context 'when status is exchanged' do
      let(:status) { 'exchanged' }

      it_behaves_like 'does not allow for transition to', :active
      it_behaves_like 'does not allow for transition to', :cancelled
      it_behaves_like 'does not allow for transition to', :inactive
      it_behaves_like 'does not allow for transition to', :exchanged
    end
  end
end
