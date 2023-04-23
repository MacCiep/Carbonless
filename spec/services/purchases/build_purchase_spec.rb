require 'rails_helper'

RSpec.describe Purchases::BuildPurchase, type: :service do
  let!(:user) { create(:user) }
  let(:params) { { uuid: machine&.uuid, points: 100, expires: expires} }
  let(:expires) do
    ActiveSupport::MessageEncryptor.new(machine.secret).encrypt_and_sign(DateTime.now + 9.minutes)
  end

  describe '#call' do
    context 'when machine is present' do
      context 'when purchase type is food' do
        let!(:machine) { create(:machine, :food) }
        let!(:service) { described_class.new(params, user) }
        subject { service.call }

        it 'returns purchase' do
          expect(subject.purchase_type_before_type_cast).to eq(2)
        end
      end

      context 'when purchase type is cloth' do
        let!(:machine) { create(:machine, :cloth) }
        let!(:service) { described_class.new(params, user) }
        subject { service.call }

        it 'returns purchase' do
          expect(subject.purchase_type_before_type_cast).to eq(1)
        end
      end
    end

    context 'when machine is not present' do
      let!(:machine) { create(:machine, :cloth) }
      let!(:service) { described_class.new(params, user) }
      let(:params) { { uuid: nil, points: 100, expires: expires} }
      subject { service.call }

      it 'returns nil' do
        expect(subject).to eq(nil)
      end
    end
  end
end