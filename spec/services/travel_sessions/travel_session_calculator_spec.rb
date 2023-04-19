require 'rails_helper'

RSpec.describe TravelSessions::TravelSessionCalculator, type: :service do
  describe '#call' do
    let!(:distance) { 10000 }
    subject { TravelSessions::TravelSessionCalculator.new(distance).call }

    it 'returns correct appropriate values' do
      expect(subject[:carbon_saved]).to eq(1.21)
      expect(subject[:points]).to eq(100)
    end
  end
end