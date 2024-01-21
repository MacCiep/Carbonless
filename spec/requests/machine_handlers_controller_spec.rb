# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::MachineHandlersController do
  let(:user) { create(:user) }

  describe 'POST #create' do
    context 'when user is not logged in' do
      before { post api_machine_handlers_path, headers: nil }

      it 'returns error' do
        expect(response).to(have_http_status(:found))
      end
    end

    context 'when user is logged in' do
      subject { post api_machine_handlers_path, params:, headers: authenticated_headers({}, user) }

      context 'when machine is travel machine' do
        let!(:machine) { create(:machine, :travel) }

        let(:params) do
          {
            handler: {
              uuid: machine.uuid,
              expires: ActiveSupport::MessageEncryptor.new(machine.secret).encrypt_and_sign(DateTime.now + 30.seconds),
              start_latitude: '51.729148231285386',
              start_longitude: '19.495436984167636'
            }
          }
        end

        context 'when params are valid' do
          it 'creates new travel session' do
            expect { subject }.to change(TravelSession, :count).by(1)
            travel_session = TravelSession.last
            expect(travel_session.user).to eq(user)
            expect(travel_session.machine).to eq(machine)
            expect(travel_session.start_latitude).to eq('51.729148231285386')
            expect(travel_session.start_longitude).to eq('19.495436984167636')
            expect(travel_session.active).to be(true)
            expect(response).to(have_http_status(:accepted))
          end
        end

        context 'when session already exists' do
          let!(:travel_session) { create(:travel_session, :active, user:, machine:) }
          let!(:expected_response) { { 'message' => 'Session is already in progress' }.to_json }

          it 'returns error' do
            subject
            expect(response).to(have_http_status(:unprocessable_entity))
            expect(response.body).to eq(expected_response)
          end
        end

        context 'when params are invalid' do
          before do
            params[:handler][:expires] =
              ActiveSupport::MessageEncryptor.new(machine.secret).encrypt_and_sign(DateTime.now + 1.day)
          end

          it 'returns error' do
            subject
            expect(response).to(have_http_status(:unprocessable_entity))
          end
        end
      end

      context 'when machine is purchase machine' do
        let(:params) do
          {
            handler: {
              uuid: machine.uuid,
              expires: ActiveSupport::MessageEncryptor.new(machine.secret).encrypt_and_sign(DateTime.now + 30.seconds)
            }
          }
        end

        context 'when machine is purchase machine' do
          let(:partner_points) { 200 }
          let!(:partner) { create(:partner, points: partner_points) }
          let!(:machine) { create(:machine, :purchase, partner:) }
          let!(:location) { create(:location, machine:) }

          let!(:expected_response) { { 'points' => partner_points, 'purchase_points' => partner_points }.to_json }

          it 'creates purchase' do
            expect { subject }.to change(Purchase, :count).by(1)
            purchase = Purchase.last
            expect(purchase.user).to eq(user)
            expect(purchase.machine).to eq(machine)
            expect(purchase.points).to eq(partner_points)
            expect(user.reload.points).to eq(partner_points)
            expect(response).to(have_http_status(:ok))
            expect(response.body).to eq(expected_response)
          end
        end
      end
    end
  end

  describe 'PATCH #update' do
    subject { patch api_machine_handlers_path, params:, headers: authenticated_headers({}, user) }

    let!(:machine) { create(:machine, :travel) }
    let!(:location) { create(:location, machine:) }
    let!(:travel_session) do
      create(:travel_session,
             :active,
             user:,
             machine:,
             start_latitude: '51.729148231285386',
             start_longitude: '19.495436984167636')
    end
    let(:params) do
      {
        handler: {
          uuid: machine.uuid,
          expires: ActiveSupport::MessageEncryptor.new(machine.secret).encrypt_and_sign(DateTime.now + 30.seconds),
          end_latitude: '52.43002147996739',
          end_longitude: '19.45364903980195'
        }
      }
    end

    context 'when user is not logged in' do
      subject { patch api_machine_handlers_path, params:, headers: nil }

      it 'returns error' do
        subject
        expect(response).to(have_http_status(:found))
      end
    end

    context 'when user is logged in' do
      context 'when params are valid', vcr: { cassette_name: 'distance_matrix/successful_request' } do
        let(:distance) { 95_355 }
        let(:session_calculator) { TravelSessions::TravelSessionCalculator.new(distance).call }
        let!(:expected_response) do
          {
            carbon_saved: session_calculator[:carbon_saved],
            points: session_calculator[:points],
            session_carbon_saved: session_calculator[:carbon_saved],
            session_points_saved: session_calculator[:points]
          }.to_json
        end

        before { subject }

        it 'updates travel session' do
          expect(travel_session.reload.end_latitude).to eq('52.43002147996739')
          expect(travel_session.end_longitude).to eq('19.45364903980195')
          expect(travel_session.success).to be(true)
          expect(travel_session.active).to be(false)
          expect(travel_session.car_distance).to eq(95_355)
          expect(response).to(have_http_status(:ok))
          expect(travel_session.points).not_to eq(0)
          expect(response.body).to eq(expected_response)
        end

        it 'updates user' do
          user.reload
          expect(user.points).to eq(session_calculator[:points])
          expect(user.total_carbon_saved).to eq(session_calculator[:carbon_saved])
          expect(user.city).not_to be_nil
          expect(user.country).not_to be_nil
          expect(user.score).to eq(session_calculator[:points])
        end
      end

      context 'when expires param is invalid' do
        before do
          params[:handler][:expires] =
            ActiveSupport::MessageEncryptor.new(machine.secret).encrypt_and_sign(DateTime.now + 1.day)
          subject
        end

        let(:expected_response) { { 'message' => 'Request is invalid' }.to_json }

        it 'returns error' do
          expect(response).to(have_http_status(:unprocessable_entity))
          expect(response.body).to eq(expected_response)
        end
      end

      context 'when location params are invalid', vcr: { cassette_name: 'distance_matrix/failed_request' } do
        let(:expected_response) { { 'message' => 'Wrong coordinates' }.to_json }

        # rubocop:disable Rails/SkipsModelValidations:
        before do
          params[:handler][:end_latitude] = '1.1241'
          params[:handler][:end_longitude] = '400.31311'
          travel_session.update_columns(start_latitude: '100.323131', start_longitude: '250.31124')
          subject
        end
        # rubocop:enable Rails/SkipsModelValidations:

        it 'returns error' do
          expect(response).to(have_http_status(:unprocessable_entity))
          expect(response.body).to eq(expected_response)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    subject { delete api_machine_handlers_path, headers: authenticated_headers({}, user) }

    let!(:machine) { create(:machine, :travel) }

    context 'when user is not logged in' do
      subject { delete api_machine_handlers_path, headers: {} }

      it 'returns error' do
        subject
        expect(response).to(have_http_status(:found))
      end
    end

    context 'when user is logged in' do
      context 'when there is active session' do
        let!(:travel_session) { create(:travel_session, :active, user:, machine:) }

        it 'deletes travel session' do
          expect { subject }.to change(TravelSession, :count).by(-1)
          expect(response).to(have_http_status(:ok))
        end
      end

      context 'when there is NO active session' do
        it 'deletes travel session' do
          subject
          expect(response).to(have_http_status(:bad_request))
        end
      end
    end
  end
end
