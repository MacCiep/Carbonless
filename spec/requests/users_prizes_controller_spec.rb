# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::UsersPrizesController do
  let(:user) { create(:user) }

  describe 'GET #index' do
    subject { get api_users_prizes_path, headers: authenticated_headers({}, user) }

    let!(:user_prize) { create(:users_prize, user:) }

    before { subject }

    it_behaves_like 'Paginated response'
  end

  describe 'POST #create' do
    context 'when user is authenticated' do
      subject { post api_users_prizes_path, params:, headers: authenticated_headers({}, user) }

      context 'when user has enough points' do
        let!(:prize) { create(:prize) }
        let!(:params) { { user_prize: { prize_id: prize.id } } }

        before do
          user.update(points: prize.price + 1)
        end

        it 'creates new user prize' do
          subject
          expect(UsersPrize.count).to eq(1)
          expect(response).to(have_http_status(:created))

          user_prize = UsersPrize.last
          expect(user_prize.user).to eq(user)
          expect(user_prize.prize).to eq(prize)
          expect(user_prize.active).to be(true)
          expect(user_prize.duration).to eq(prize.duration)
        end
      end

      context 'when user does not have enough points' do
        let!(:prize) { create(:prize) }
        let!(:params) { { user_prize: { prize_id: prize.id } } }

        before do
          user.update(points: prize.price - 1)
        end

        it 'returns error' do
          subject
          expect(UsersPrize.count).to eq(0)
          expect(response).to(have_http_status(:unprocessable_entity))
        end
      end
    end
  end

  describe 'PATCH #update' do
    subject { patch api_users_prize_path(user_prize.id), headers: authenticated_headers({}, user) }

    let(:user) { create(:user, :business) }
    let!(:user_prize) { create(:users_prize) }

    context 'when user is business type, prize is active and there is still time left' do
      it 'deactivates prize and returns 200' do
        subject
        expect(user_prize.reload.active).to be(false)
        expect(response).to(have_http_status(:ok))
      end
    end

    context 'when user is normal type' do
      let!(:user) { create(:user) }

      it 'returns 403' do
        subject
        expect(response).to(have_http_status(:forbidden))
      end
    end

    context 'when prize is not active' do
      before do
        user_prize.update(active: false)
      end

      it 'returns 403' do
        subject
        expect(response).to(have_http_status(:forbidden))
      end
    end

    context 'when duration was passed' do
      before do
        user_prize.update(active: false)
        allow(DateTime).to receive(:now).and_return(DateTime.now + user_prize.duration.days)
      end

      it 'returns 403' do
        subject
        expect(response).to(have_http_status(:forbidden))
      end
    end
  end

  describe 'GET #show' do
    subject { get(api_users_prize_path(user_prize), headers: authenticated_headers({}, user)) }

    let!(:user_prize) { create(:users_prize) }

    before do
      subject
    end

    context 'when user is business type' do
      let!(:user) { create(:user, :business) }

      it 'returns 200' do
        expect(response).to(have_http_status(:ok))
      end
    end

    context 'when user is normal type' do
      let!(:user) { create(:user) }

      it 'returns 403' do
        expect(response).to(have_http_status(:forbidden))
      end
    end
  end
end
