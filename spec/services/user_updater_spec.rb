require 'rails_helper'

RSpec.describe UserUpdater do
  let(:user) { create(:user) }

  describe '#call' do
    subject { UserUpdater.new(user: user, points: 10, carbon_saved: 10).call }

    it 'updates user carbon_saved and points' do
      expect { subject }.to change { user.reload.total_carbon_saved }.by(10)
                        .and change { user.reload.points }.by(10)
    end
  end
end