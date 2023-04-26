require 'rails_helper'

RSpec.describe Purchases::Validator, type: :service do
  let!(:user) { create(:user) }
  let!(:machine) { create(:machine, :food) }
  let!(:machine_params) { { uuid: machine.uuid, expires: expires } }

  describe '#call' do
    let(:validator) { described_class.new(machine, expires, user) }
    subject { validator.call }

    context 'when everything is correct' do
      let!(:expires) do
        ActiveSupport::MessageEncryptor.new(machine.secret).encrypt_and_sign(DateTime.now + 5.minutes)
      end

      it 'returns true' do
        is_expected.to eq(true)
      end
    end

    context 'when data is incorrect' do
      context 'when verification is too late' do
        let!(:expires) do
          ActiveSupport::MessageEncryptor.new(machine.secret).encrypt_and_sign(DateTime.now - 10.minutes)
        end

        it 'returns true' do
          is_expected.to eq(false)
        end
      end

      context 'when verification is too early' do
        let!(:expires) do
          ActiveSupport::MessageEncryptor.new(machine.secret).encrypt_and_sign(DateTime.now -1.minutes)
        end

        it 'returns true' do
          is_expected.to eq(false)
        end
      end

      context 'when verification time is too late' do
        let!(:expires) do
          ActiveSupport::MessageEncryptor.new(machine.secret).encrypt_and_sign(DateTime.now + 90.minutes)
        end

        it 'returns false' do
          allow(DateTime).to receive(:now).and_return(DateTime.now + 91.minutes)
          is_expected.to eq(false)
        end
      end

      context 'when time between purchases is too short' do
        let!(:purchase) { create(:purchase, user: user) }

        let!(:expires) do
          ActiveSupport::MessageEncryptor.new(machine.secret).encrypt_and_sign(DateTime.now + 5.minutes)
        end

        it 'returns false' do
          is_expected.to eq(false)
        end
      end

      context 'when time between purchases is correct' do
        let!(:purchase) { create(:purchase, user: user) }

        let!(:expires) do
          ActiveSupport::MessageEncryptor.new(machine.secret).encrypt_and_sign(DateTime.now + 5.minutes)
        end

        it 'returns false' do
          allow(DateTime).to receive(:now).and_return(DateTime.now + 20.seconds)
          is_expected.to eq(true)
        end
      end
    end
  end
end