# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::PointsHistoriesController do
  describe 'GET #index' do
    it_behaves_like 'protected endpoint', method: :get, url: '/api/points_histories.json'

    context 'when user is logged in' do
      subject { send(:get, api_points_histories_path, headers:, params: nil) }

      let(:user) { create(:user) }
      let(:headers) { authenticated_headers({}, user) }
      let!(:purchase) { create(:purchase, user:) }
      let!(:travel_session) { create(:travel_session, :completed, user:) }
      let!(:user_prize) { create(:users_prize, user:) }

      before { subject }

      it 'returns http success' do
        expect(response).to(have_http_status(:success))
      end

      it 'contains all 3 types' do
        expect(response.parsed_body.pluck('history_type')).to eq(%w[prize travel purchase])
      end

      it 'sorts by created_at' do
        sorted_list = response.parsed_body.sort_by { |point_history| point_history['created_at'].to_date }
        expect(response.parsed_body).to eq(sorted_list)
      end
    end
  end
end
