# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserUpdater do
  let(:user) { create(:user) }
  let(:partner) { create(:partner, points: 200) }
  let!(:machine) { create(:machine, partner:) }
  let!(:location) { create(:location, machine:) }

  describe '#call' do
    context 'when points are provided' do
      subject(:service) { described_class.new(user:, machine:, points: 10, carbon_saved: 10).call }

      it "updates user's carbon_saved" do
        expect { service }.to change(user, :total_carbon_saved).by(10)
      end

      it "updates user's points" do
        expect { service }.to change(user, :points).by(10)
      end

      it "updates user's city" do
        expect { service }.to change(user, :city).to(location.city)
      end

      it "updates user's country" do
        expect { service }.to change(user, :country).to(location.country)
      end

      it "updates user's score" do
        expect { service }.to change { user.reload.score }.by(10)
      end
    end

    context 'when points and carbon_saved are NOT provided' do
      subject(:service) { described_class.new(user:, machine:).call }

      it "updates user's carbon_saved" do
        expect { service }.not_to(change(user, :total_carbon_saved))
      end

      it "updates user's points" do
        expect { service }.to change(user, :points).by(partner.points)
      end

      it "updates user's city" do
        expect { service }.to change(user, :city).to(location.city)
      end

      it "updates user's country" do
        expect { service }.to change(user, :country).to(location.country)
      end

      it "updates user's score" do
        expect { service }.to change(user, :score).by(partner.points)
      end
    end
  end
end
