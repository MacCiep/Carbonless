# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::ExchangeOffersController do
  let(:user) { create(:user) }

  describe 'GET #index' do
    it_behaves_like 'protected endpoint', method: :get, url: '/api/exchange_offers.json'

    context 'when user is logged in' do
      subject(:request) { get api_exchange_offers_path, params:, headers: }

      let(:headers) { authenticated_headers({}, user) }

      context 'when scope is NOT provided' do
        before { request }

        let(:params) { {} }

        it_behaves_like 'response status', :unprocessable_entity
      end

      context 'when scope is NOT valid' do
        before { request }

        let(:params) { { scope: 'test' } }

        it_behaves_like 'response status', :unprocessable_entity
      end

      context 'when scope is others' do
        let(:params) { { scope: 'others' } }

        let!(:exchange_item) { create(:exchange_item, user:) }
        let!(:exchange_offer) { create(:exchange_offer, exchange_item:) }
        let!(:my_exchange_offer) { create(:exchange_offer, user:) }

        before { request }

        it_behaves_like 'Paginated response'

        it 'returns only exchange offers for exchange items created by user' do
          records = response.parsed_body['records']
          expect(records[0].to_json).to eq(ExchangeOfferBlueprint.render_as_hash(exchange_offer).to_json)
          expect(records.count).to eq(1)
        end
      end

      context 'when scope is my' do
        let(:params) { { scope: 'my' } }

        let(:other_exchange_item) { create(:exchange_item) }
        let!(:my_exchange_offer) { create(:exchange_offer, exchange_item: other_exchange_item, user:) }
        let(:my_exchange_item) { create(:exchange_item, user:) }
        let!(:exchange_offer) { create(:exchange_offer, exchange_item: my_exchange_item) }

        before { request }

        it_behaves_like 'Paginated response'

        it 'returns only exchange offers created by user' do
          records = response.parsed_body['records']
          expect(records[0].to_json).to eq(ExchangeOfferBlueprint.render_as_hash(my_exchange_offer).to_json)
          expect(records.count).to eq(1)
        end
      end

      context 'when status is provided' do
        let(:params) { { scope: 'my', status: 'accepted' } }

        let!(:exchange_offer) { create(:exchange_offer, status: :accepted, user:) }
        let!(:other_exchange_offer) { create(:exchange_offer, status: :pending, user:) }

        before { request }

        it_behaves_like 'Paginated response'

        it 'returns only exchange offers with provided status' do
          records = response.parsed_body['records']
          expect(records[0].to_json).to eq(ExchangeOfferBlueprint.render_as_hash(exchange_offer).to_json)
          expect(records.count).to eq(1)
        end
      end
    end
  end

  describe 'GET #show' do
    it_behaves_like 'protected endpoint', method: :get, url: '/api/exchange_offers/1.json'

    context 'when user is logged in' do
      subject(:request) { get api_exchange_offer_path(exchange_offer), headers: }

      let(:user) { create(:user) }
      let(:headers) { authenticated_headers({}, user) }
      let(:exchange_offer) { create(:exchange_offer) }
      let(:expected_response) do
        {
          created_at: exchange_offer.created_at,
          description: exchange_offer.description,
          exchange_item_id: exchange_offer.exchange_item_id,
          id: exchange_offer.id,
          updated_at: exchange_offer.updated_at,
          user_id: exchange_offer.user_id
        }
      end

      before { request }

      it 'returns 200' do
        expect(response).to(have_http_status(:ok))
      end

      it 'returns exchange offer' do
        expect(response.body).to eq(expected_response.to_json)
      end
    end
  end

  describe 'POST #create' do
    it_behaves_like 'protected endpoint', method: :post, url: '/api/exchange_offers.json'

    context 'when user is authenticated' do
      subject(:request) { post api_exchange_offers_path, params:, headers: authenticated_headers({}, user) }

      context 'when exchange item does not exist' do
        let(:params) { { exchange_offer: { exchange_item_id: 1, description: Faker::Lorem.paragraph } } }

        before { request }

        it_behaves_like 'response status', :unprocessable_entity
      end

      context 'when user is an owner of exchange item' do
        let(:exchange_item) { create(:exchange_item, user:) }
        let(:params) { { exchange_offer: { exchange_item_id: exchange_item.id, description: Faker::Lorem.paragraph } } }

        before { request }

        # it 'test' do
        #   debugger
        # end
        it_behaves_like 'response status', :unprocessable_entity
      end

      context 'when message includes profanity', vcr: { cassette_name: 'moderation/flagged_message' } do
        let(:exchange_item) { create(:exchange_item) }
        let(:params) { { exchange_offer: { exchange_item_id: exchange_item.id, description: 'Really bad word' } } }
        let(:expected_response) do
          {
            'errors' => [
              'Please do not use bad words in description, if this happens again your account will be blocked'
            ]
          }
        end

        before { request }

        it_behaves_like 'response status', :unprocessable_entity

        it 'returns' do
          expect(response.parsed_body).to eq(expected_response)
        end
      end

      context 'when user is NOT an owner of exchange item', vcr: { cassette_name: 'moderation/casual_message' } do
        let(:exchange_item) { create(:exchange_item) }
        let(:params) { { exchange_offer: { exchange_item_id: exchange_item.id, description: Faker::Lorem.paragraph } } }

        it 'creates new exchange offer' do
          expect { subject }.to change(ExchangeOffer, :count).by(1)
        end

        it 'returns 201' do
          subject
          expect(response).to(have_http_status(:created))
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    it_behaves_like 'protected endpoint', method: :delete, url: '/api/exchange_offers/1.json'

    context 'when user is authenticated' do
      subject(:request) { delete api_exchange_offer_path(exchange_offer), headers: authenticated_headers({}, user) }

      context 'when user is not an owner of exchange item' do
        let(:exchange_offer) { create(:exchange_offer) }

        before { request }

        it_behaves_like 'response status', :forbidden
      end

      context 'when user is an owner of exchange item' do
        let(:user) { create(:user) }
        let!(:exchange_offer) { create(:exchange_offer, user:) }

        it 'deletes exchange offer' do
          expect { subject }.to change(ExchangeOffer, :count).by(-1)
        end

        it 'returns 204' do
          subject
          expect(response).to(have_http_status(:no_content))
        end
      end
    end
  end

  describe 'PATCH #accept' do
    it_behaves_like 'protected endpoint', method: :patch, url: '/api/exchange_offers/1/accept.json'

    context 'when user is authenticated' do
      subject(:request) do
        patch accept_api_exchange_offer_path(exchange_offer), params:, headers: authenticated_headers({}, user)
      end

      let(:params) { {} }

      context 'when user is not an owner of exchange item' do
        let(:exchange_offer) { create(:exchange_offer, status: :pending) }

        before { request }

        it_behaves_like 'response status', :forbidden
      end

      context 'when response_description is not provided' do
        let(:user) { create(:user) }
        let(:exchange_item) { create(:exchange_item, user:) }
        let!(:exchange_offer) { create(:exchange_offer, exchange_item:) }

        before { request }

        it_behaves_like 'response status', :bad_request
      end

      context 'when response_description contain profanity', vcr: { cassette_name: 'moderation/flagged_message' } do
        let(:user) { create(:user) }
        let(:exchange_item) { create(:exchange_item, user:) }
        let!(:exchange_offer) { create(:exchange_offer, exchange_item:) }
        let(:expected_response) do
          {
            'errors' => [
              'Please do not use bad words in description, if this happens again your account will be blocked'
            ]
          }
        end

        let(:params) { { exchange_offer: { response_description: 'Really bad word' } } }

        before { request }

        it 'returns 422' do
          expect(response).to(have_http_status(:unprocessable_entity))
        end

        it 'returns' do
          expect(response.parsed_body).to eq(expected_response)
        end
      end

      context 'when user is an owner of exchange item', vcr: { cassette_name: 'moderation/casual_message' } do
        let(:user) { create(:user) }
        let(:exchange_item) { create(:exchange_item, user:) }
        let!(:exchange_offer) { create(:exchange_offer, exchange_item:) }

        let(:params) { { exchange_offer: { response_description: Faker::Lorem.paragraph } } }

        it 'accepts exchange offer' do
          expect { subject }.to change { exchange_offer.reload.status }.from('pending').to('accepted')
        end

        it 'returns 200' do
          subject
          expect(response).to(have_http_status(:ok))
        end
      end
    end
  end

  describe 'PATCH #reject' do
    it_behaves_like 'protected endpoint', method: :patch, url: '/api/exchange_offers/1/reject.json'

    context 'when user is authenticated' do
      subject(:request) do
        patch reject_api_exchange_offer_path(exchange_offer), params:, headers: authenticated_headers({}, user)
      end

      let(:params) { {} }

      context 'when user is not an owner of exchange item' do
        let(:exchange_offer) { create(:exchange_offer) }

        before { request }

        it_behaves_like 'response status', :forbidden
      end

      context 'when response_description is not provided' do
        let(:user) { create(:user) }
        let(:exchange_item) { create(:exchange_item, user:) }
        let!(:exchange_offer) { create(:exchange_offer, exchange_item:) }

        before { request }

        it_behaves_like 'response status', :bad_request
      end

      context 'when response_description contain profanity', vcr: { cassette_name: 'moderation/flagged_message' } do
        let(:user) { create(:user) }
        let(:exchange_item) { create(:exchange_item, user:) }
        let!(:exchange_offer) { create(:exchange_offer, exchange_item:) }
        let(:expected_response) do
          {
            'errors' =>
              ['Please do not use bad words in description, if this happens again your account will be blocked']
          }
        end

        let(:params) { { exchange_offer: { response_description: 'Really bad word' } } }

        before { request }

        it 'returns 422' do
          expect(response).to(have_http_status(:unprocessable_entity))
        end

        it 'returns' do
          expect(response.parsed_body).to eq(expected_response)
        end
      end

      context 'when user is an owner of exchange item', vcr: { cassette_name: 'moderation/casual_message' } do
        let(:user) { create(:user) }
        let(:exchange_item) { create(:exchange_item, user:) }
        let!(:exchange_offer) { create(:exchange_offer, exchange_item:) }

        let(:params) { { exchange_offer: { response_description: Faker::Lorem.paragraph } } }

        it 'rejects exchange offer' do
          expect { subject }.to change { exchange_offer.reload.status }.from('pending').to('rejected')
        end

        it 'returns 200' do
          subject
          expect(response).to(have_http_status(:ok))
        end
      end
    end

    describe 'PATCH #complete' do
      it_behaves_like 'protected endpoint', method: :patch, url: '/api/exchange_offers/1/complete.json'

      context 'when user is authenticated' do
        subject(:request) do
          patch complete_api_exchange_offer_path(exchange_offer), headers: authenticated_headers({}, user)
        end

        context 'when user is not an owner of exchange offer' do
          let(:exchange_offer) { create(:exchange_offer) }

          before { request }

          it_behaves_like 'response status', :forbidden
        end

        context 'when user is an owner of exchange offer' do
          let(:user) { create(:user) }
          let!(:exchange_item) { create(:exchange_item, status: :active) }
          let!(:exchange_offer) { create(:exchange_offer, user:, status: :accepted, exchange_item:) }

          it 'completes exchange offer' do
            expect { subject }.to change { exchange_offer.reload.status }.from('accepted').to('completed')
          end

          it 'changes exchange item status to exchanged' do
            expect { subject }.to change { exchange_offer.exchange_item.reload.status }.from('active').to('exchanged')
          end

          it 'returns 200' do
            subject
            expect(response).to(have_http_status(:ok))
          end
        end
      end
    end
  end
end
