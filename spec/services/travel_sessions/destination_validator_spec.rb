# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TravelSessions::DestinationValidator, type: :service do
  let!(:user) { create(:user) }
  let!(:machine) { create(:machine, :travel) }
  let!(:travel_session) { create(:travel_session, :inactive, user:, machine:) }

  describe '#call' do
    subject { validator.call }

    let(:validator) { described_class.new(machine, expires, travel_session) }

    describe 'when current session is not present' do
      let!(:travel_session) { nil }

      context 'when verification is in correct time box' do
        let!(:expires) do
          ActiveSupport::MessageEncryptor.new(machine.secret).encrypt_and_sign(DateTime.now + 10.minutes)
        end

        it 'returns false' do
          expect(subject).to be(false)
        end
      end
    end

    describe 'when current session is present' do
      context 'when verification is in correct time box' do
        let!(:expires) do
          ActiveSupport::MessageEncryptor.new(machine.secret).encrypt_and_sign(DateTime.now + 10.minutes)
        end

        it 'returns true' do
          expect(subject).to be(true)
        end
      end

      context 'when verification is too late' do
        let!(:expires) do
          ActiveSupport::MessageEncryptor.new(machine.secret).encrypt_and_sign(DateTime.now - 10.minutes)
        end

        it 'returns true' do
          expect(subject).to be(false)
        end
      end

      context 'when verification is too early' do
        let!(:expires) do
          ActiveSupport::MessageEncryptor.new(machine.secret).encrypt_and_sign(DateTime.now + 21.minutes)
        end

        it 'returns true' do
          expect(subject).to be(false)
        end
      end

      context 'when verification time is correct' do
        let!(:expires) do
          ActiveSupport::MessageEncryptor.new(machine.secret).encrypt_and_sign(DateTime.now + 90.minutes)
        end

        it 'returns true' do
          allow(DateTime).to receive(:now).and_return(DateTime.now + 89.minutes)
          expect(subject).to be(true)
        end
      end

      context 'when verification time is too late' do
        let!(:expires) do
          ActiveSupport::MessageEncryptor.new(machine.secret).encrypt_and_sign(DateTime.now + 90.minutes)
        end

        it 'returns false' do
          allow(DateTime).to receive(:now).and_return(DateTime.now + 91.minutes)
          expect(subject).to be(false)
        end
      end
    end
  end
end
