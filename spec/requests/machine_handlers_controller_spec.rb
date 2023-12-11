require 'rails_helper'

RSpec.describe Api::MachineHandlersController, type: :request do
  let(:user) { create(:user) }

  describe 'POST #create' do
    context 'when user is not logged in' do
      before { post api_machine_handlers_path, headers: nil }

      it 'returns error' do
        expect(response).to(have_http_status(302))
      end
    end

    context 'when user is logged in' do
      subject { post api_machine_handlers_path, params: params, headers: authenticated_headers({}, user) }

      context 'when machine is travel machine' do
        let!(:machine) { create(:machine, :travel) }

        let(:params) do
          {
            handler: {
              uuid: machine.uuid,
              expires: ActiveSupport::MessageEncryptor.new(machine.secret).encrypt_and_sign(DateTime.now + 30.seconds),
              start_latitude: '51.729148231285386',
              start_longitude: '19.495436984167636',
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
            expect(travel_session.active).to eq(true)
            expect(response).to(have_http_status(202))
          end
        end

        context 'when session already exists' do
          let!(:travel_session) { create(:travel_session, :active, user: user, machine: machine) }
          let!(:expected_response) { { 'message' => 'Session is already in progress' }.to_json }
          it 'returns error' do
            subject
            expect(response).to(have_http_status(422))
            expect(response.body).to eq(expected_response)
          end
        end

        context 'when params are invalid' do
          before { params[:handler][:expires] = ActiveSupport::MessageEncryptor.new(machine.secret).encrypt_and_sign(DateTime.now + 1.day) }

          it 'returns error' do
            subject
            expect(response).to(have_http_status(422))
          end
        end
      end

      context 'when machine is purchase machine' do
        let(:params) do
          {
            handler: {
              uuid: machine.uuid,
              expires: ActiveSupport::MessageEncryptor.new(machine.secret).encrypt_and_sign(DateTime.now + 30.seconds),
            }
          }
        end

        context 'when machine is purchase machine' do
          let(:partner_points) { 200 }
          let!(:partner) { create(:partner, points: partner_points) }
          let!(:machine) { create(:machine, :purchase, partner: partner) }
          let!(:location) { create(:location, machine: machine) }

          let!(:expected_response) { { 'points' => partner_points, 'purchase_points' => partner_points }.to_json }

          it 'creates purchase' do
            expect { subject }.to change(Purchase, :count).by(1)
            purchase = Purchase.last
            expect(purchase.user).to eq(user)
            expect(purchase.machine).to eq(machine)
            expect(purchase.points).to eq(partner_points)
            expect(user.reload.points).to eq(partner_points)
            expect(response).to(have_http_status(200))
            expect(response.body).to eq(expected_response)
          end
        end
      end
    end
  end

  describe 'PATCH #update' do
    let!(:machine) { create(:machine, :travel) }
    let!(:location) { create(:location, machine: machine) }
    let!(:travel_session) { create(:travel_session,
                                   :active,
                                   user: user,
                                   machine: machine,
                                   start_latitude: '51.729148231285386',
                                   start_longitude: '19.495436984167636') }
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

    subject { patch api_machine_handlers_path, params: params, headers: authenticated_headers({}, user) }

    context 'when user is not logged in' do
      subject { patch api_machine_handlers_path, params: params, headers: nil }

      it 'returns error' do
        subject
        expect(response).to(have_http_status(302))
      end
    end

    context 'when user is logged in' do
      context 'when params are valid', vcr: { cassette_name: 'distance_matrix/successful_request' } do
        let(:distance) { 95355 }
        let(:session_calculator) { session = TravelSessions::TravelSessionCalculator.new(distance).call }
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
          expect(travel_session.success).to eq(true)
          expect(travel_session.active).to eq(false)
          expect(travel_session.car_distance).to eq(95355)
          expect(response).to(have_http_status(200))
          expect(travel_session.points).not_to eq(0)
          expect(response.body).to eq(expected_response)
        end

        it 'updates user' do
          user.reload
          expect(user.points).to eq(session_calculator[:points])
          expect(user.total_carbon_saved).to eq(session_calculator[:carbon_saved])
          expect(user.city).not_to eq(nil)
          expect(user.country).not_to eq(nil)
          expect(user.score).to eq(session_calculator[:points])
        end
      end

      context 'when expires param is invalid' do
        before do
          params[:handler][:expires] = ActiveSupport::MessageEncryptor.new(machine.secret).encrypt_and_sign(DateTime.now + 1.day)
          subject
        end

        let(:expected_response) { { 'message' => 'Request is invalid' }.to_json }

        it 'returns error' do
          expect(response).to(have_http_status(422))
          expect(response.body).to eq(expected_response)
        end
      end

      context 'when location params are invalid', vcr: { cassette_name: 'distance_matrix/failed_request' } do
        let(:expected_response) { { 'message' => 'Wrong coordinates' }.to_json }

        before do
          params[:handler][:end_latitude] = '1.1241'
          params[:handler][:end_longitude] = '400.31311'
          travel_session.update_columns(start_latitude: '100.323131', start_longitude: '250.31124')
          subject
        end

        it 'returns error' do
          expect(response).to(have_http_status(422))
          expect(response.body).to eq(expected_response)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:machine) { create(:machine, :travel) }

    subject { delete api_machine_handlers_path, headers: authenticated_headers({}, user) }

    context 'when user is not logged in' do
      subject { delete api_machine_handlers_path, headers: {} }

      it 'returns error' do
        subject
        expect(response).to(have_http_status(302))
      end
    end

    context 'when user is logged in' do
      context 'when there is active session' do
        let!(:travel_session) { create(:travel_session, :active, user: user, machine: machine) }

        it 'deletes travel session' do
          expect { subject }.to change(TravelSession, :count).by(-1)
          expect(response).to(have_http_status(200))
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