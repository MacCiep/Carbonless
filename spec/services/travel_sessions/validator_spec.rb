require 'rails_helper'

RSpec.describe TravelSessions::Validator, type: :service do
  let!(:user) { create(:user) }
  let!(:machine) { create(:machine, :travel) }
  let!(:travel_session) { create(:travel_session, :inactive, user: user, machine: machine) }

  shared_examples 'validator' do
    subject { validator.call }

    context 'when verification is in correct time box' do
      let!(:expires) do ActiveSupport::MessageEncryptor.new(machine.secret).encrypt_and_sign(DateTime.now + 10.minutes) end

      it 'returns true' do is_expected.to eq(true) end
    end

    context 'when verification is too late' do
      let!(:expires) do ActiveSupport::MessageEncryptor.new(machine.secret).encrypt_and_sign(DateTime.now - 10.minutes) end

      it 'returns true' do is_expected.to eq(false) end
    end

    context 'when verification is too early' do
      let!(:expires) do ActiveSupport::MessageEncryptor.new(machine.secret).encrypt_and_sign(DateTime.now + 21.minutes) end

      it 'returns true' do is_expected.to eq(false) end
    end
  end

  describe '#call' do
    let!(:machine_params) { { uuid: machine.uuid, expires: expires } }
    let!(:validator) { TravelSessions::Validator.new(machine_params, travel_session) }
    subject { validator.call }

    describe 'when current session is not present' do
      let!(:travel_session) { nil }

      it_behaves_like 'validator'
    end

    describe 'when current session is present' do
      it_behaves_like 'validator'

      context 'when verification time is correct' do
        let!(:expires) do ActiveSupport::MessageEncryptor.new(machine.secret).encrypt_and_sign(DateTime.now + 90.minutes) end

        it 'returns true' do
          allow(DateTime).to receive(:now).and_return(DateTime.now + 89.minutes)
          is_expected.to eq(true)
        end
      end

      context 'when machine uuid do NOT match' do
        let!(:other_machine) { create(:machine, :travel) }
        let!(:expires) do ActiveSupport::MessageEncryptor.new(machine.secret).encrypt_and_sign(DateTime.now + 10.minutes) end
        let!(:machine_params) { { uuid: other_machine.uuid, expires: expires } }

        it 'returns true' do
          is_expected.to eq(false)
        end
      end

      context 'when verification time is too late' do
        let!(:expires) do ActiveSupport::MessageEncryptor.new(machine.secret).encrypt_and_sign(DateTime.now + 90.minutes) end

        it 'returns false' do
          allow(DateTime).to receive(:now).and_return(DateTime.now + 91.minutes)
          is_expected.to eq(false)
        end
      end
    end
  end
end