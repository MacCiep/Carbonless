require 'rails_helper'

RSpec.describe DistanceMatrix::Requests::CalculateDistance, type: :service do
  let!(:user) { create(:user) }
  let!(:travel_session) do
    create(:travel_session,
           user: user,
           start_latitude: '51.729148231285386',
           start_longitude: '19.495436984167636',
           end_latitude: '52.43002147996739',
           end_longitude: '19.45364903980195')
  end

  describe '#call' do
    context 'when origins and destinations are correct', vcr: { cassette_name: 'distance_matrix/successful_request' } do
      let(:request) { described_class.new(travel_session) }
      subject { request.call }

      it 'returns correct distance' do
        expect(subject).to eq(95355)
      end
    end

    context 'when origins and destinations are incorrect', vcr: { cassette_name: 'distance_matrix/failed_request' } do
      let(:request) { described_class.new(travel_session) }
      subject { request.call }

      before do
        travel_session.update(start_latitude: '100.323131',
                              start_longitude: '250.31124',
                              end_latitude: '1.1241',
                              end_longitude: '400.31311')
      end

      it 'returns correct distance' do
        expect(subject).to eq(nil)
      end
    end
  end
end