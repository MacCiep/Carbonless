# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TravelSessions::TravelSessionCalculator, type: :service do
  describe '#call' do
    subject(:service) { described_class.new(distance).call }

    let!(:distance) { 10_000 }

    it 'returns correct appropriate values' do
      expect(service[:carbon_saved]).to eq(1.21)
      expect(service[:points]).to eq(100)
    end
  end
end
