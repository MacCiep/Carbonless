require 'rails_helper'

RSpec.describe Api::UsersPrizesController, type: :request do
  let(:user) { create(:user) }

  describe 'GET #index' do
    let!(:user_prize) { create(:users_prize, user: user) }

    subject { get api_users_prizes_path, headers: authenticated_headers({}, user) }

    before { subject}
    it_behaves_like "Paginated response"
  end

  describe 'POST #create' do
    context 'when user is authenticated' do
      subject { post api_users_prizes_path, params: params, headers: authenticated_headers({}, user) }

      context 'when user has enough points' do
        let!(:prize) { create(:prize) }
        let!(:params) { { user_prize: { prize_id: prize.id } } }

        before do
          user.update(points: prize.price + 1)
        end

        it 'creates new user prize' do
          subject
          expect(UsersPrize.count).to eq(1)
          expect(response).to(have_http_status(201))

          user_prize = UsersPrize.last
          expect(user_prize.user).to eq(user)
          expect(user_prize.prize).to eq(prize)
          expect(user_prize.active).to eq(true)
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
          expect(response).to(have_http_status(422))
        end
      end
    end
  end

  describe 'PATCH #update' do
    let(:user) { create(:user, :business) }
    let!(:user_prize) { create(:users_prize) }

    subject { patch api_users_prize_path(user_prize.id), headers: authenticated_headers({}, user) }

    context 'when user is business type, prize is active and there is still time left' do

      it 'deactivates prize and returns 200' do
        subject
        expect(user_prize.reload.active).to eq(false)
        expect(response).to(have_http_status(200))
      end
    end

    context 'when user is normal type' do
      let!(:user) { create(:user) }

      it 'returns 403' do
        subject
        expect(response).to(have_http_status(403))
      end
    end

    context 'when prize is not active' do
      before do
        user_prize.update(active: false)
      end

      it 'returns 403' do
        subject
        expect(response).to(have_http_status(403))
      end
    end

    context 'when duration was passed' do
      before do
        user_prize.update(active: false)
        allow(DateTime).to receive(:now).and_return(DateTime.now + user_prize.duration.days)
      end

      it 'returns 403' do
        subject
        expect(response).to(have_http_status(403))
      end
    end
  end

  describe 'GET #show' do
    let!(:user_prize) { create(:users_prize) }

    before do
      subject
    end

    subject { get(api_users_prize_path(user_prize), headers: authenticated_headers({}, user)) }

    context 'when user is business type' do
      let!(:user) { create(:user, :business) }

      it 'returns 200' do
        expect(response).to(have_http_status(200))
      end
    end

    context 'when user is normal type' do
      let!(:user) { create(:user) }

      it 'returns 403' do
        expect(response).to(have_http_status(403))
      end
    end
  end
end