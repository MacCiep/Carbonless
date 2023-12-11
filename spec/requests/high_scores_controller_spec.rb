require 'rails_helper'

RSpec.describe Api::HighScoresController, type: :request do
  describe 'GET #index' do
    it_behaves_like 'protected endpoint', method: :get, url: '/api/high_scores.json'

    context 'when user is logged in' do
      subject { send(:get, api_high_scores_path, headers: headers, params: params) }
      let(:user) { create(:user, city: 'Lodz', country: 'Poland') }
      let(:headers) { authenticated_headers({}, user) }

      before do
        (1..10).each do
          create(:user, score: rand(1..100), city: 'Lodz', country: 'Poland')
        end

        subject
      end

      let(:expected_response) do
        {
          leader_board: leader_board,
          rank: user_rank,
          score: user.score,
          username: user.username
        }.to_json
      end

      shared_examples 'high_score response' do
        it 'returns http success' do
          expect(response).to(have_http_status(:success))
        end

        it 'returns users in order' do
          expect(response.body).to eq(expected_response)
        end
      end

      context 'when no scope is provided' do
        let(:params) { nil }
        let(:user_rank) { user.global_rank }
        let(:leader_board) { User.order(score: :desc).limit(5) }

        it_behaves_like 'high_score response'
      end

      context 'when city scope is provided' do
        let(:city) { 'Lodz' }
        let(:params) { { 'scope': 'city', scope_value: city }  }
        let(:user_rank) { user.city_rank(city) }
        let(:leader_board) { User.where(city: city).order(score: :desc).limit(5) }

        before { create(:user, score: 101, city: 'Krakow') }

        it_behaves_like 'high_score response'
      end

      context 'when country scope is provided' do
        let(:country) { 'Poland' }
        let(:params) { { 'scope': 'country', scope_value: country }  }
        let(:user_rank) { user.country_rank(country) }
        let(:leader_board) { User.where(country: country).sort_by(&:score).reverse.first(5) }

        before { create(:user, score: 101, country: 'Finland') }

        it_behaves_like 'high_score response'
      end
    end
  end
end