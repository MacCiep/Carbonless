require 'rails_helper'

RSpec.describe Api::ExchangeItemsController, type: :request do
  let(:user) { create(:user) }

  describe 'GET #index' do
    it_behaves_like 'protected endpoint', method: :get, url: '/api/exchange_items.json'

    context 'when user is logged in' do
      subject { get api_exchange_items_path, headers: headers }
      let(:headers) { authenticated_headers({}, user) }
      before do
        create(:exchange_item)
        subject
      end

      it_behaves_like "Paginated response"
    end
  end

  describe 'GET #show' do
    it_behaves_like 'protected endpoint', method: :get, url: '/api/exchange_items/1.json'

    context 'when user is logged in' do
      subject { get api_exchange_item_path(exchange_item), headers: headers }
      let(:user) { create(:user) }
      let(:headers) { authenticated_headers({}, user) }
      let(:exchange_item) { create(:exchange_item) }
      let(:expected_response) do
        {
          created_at: exchange_item.created_at,
          description: exchange_item.description,
          id: exchange_item.id,
          name: exchange_item.name,
          updated_at: exchange_item.updated_at,
        }
      end

      before { subject }

      it 'returns 200' do
        expect(response).to(have_http_status(200))
      end

      it 'returns exchange item' do
        expect(response.body).to eq(expected_response.to_json)
      end
    end
  end

  describe 'POST #create' do
    it_behaves_like 'protected endpoint', method: :post, url: '/api/exchange_items.json'

    context 'when user is authenticated' do
      subject { post api_exchange_items_path, params: params, headers: authenticated_headers({}, user) }

      context 'when message includes profanity', vcr: { cassette_name: 'moderation/flagged_message' } do
        let(:params) { { exchange_item: { name: Faker::Books.name, description: 'Really bad word' } } }
        let(:expected_response) do
          {
            "errors" => ['Please do not use bad words in description, if this happens again your account will be blocked']
          }
        end

        before { subject }

        it_behaves_like 'response status', :unprocessable_entity

        it 'returns' do
          expect(JSON.parse(response.body)).to eq(expected_response)
        end
      end

      context 'when message does not include profanity', vcr: { cassette_name: 'moderation/casual_message' } do
        let(:params) { { exchange_item: { name: Faker::Books.name, description: Faker::Lorem.paragraph } } }

        it 'creates new exchange item' do
          expect { subject }.to change { ExchangeItem.count }.by(1)
        end

        it 'returns 201' do
          subject
          expect(response).to(have_http_status(201))
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    it_behaves_like 'protected endpoint', method: :delete, url: "/api/exchange_items/1.json"

    subject { delete api_exchange_item_path(exchange_item), headers: authenticated_headers({}, user) }

    context 'when user is authenticated' do
      context 'when user is not an owner of exchange item' do
        let(:exchange_item) { create(:exchange_item) }

        before { subject }

        it 'returns 403' do
          expect(response).to(have_http_status(403))
        end
      end

      context 'when user is an owner of exchange item' do
        let!(:exchange_item) { create(:exchange_item, user:) }

        it 'returns 204' do
          subject
          expect(response).to(have_http_status(204))
        end

        it 'deletes exchange item' do
          expect { subject }.to change { ExchangeItem.count }.by(-1)
        end
      end
    end
  end

  describe 'PATCH #update' do
    it_behaves_like 'protected endpoint', method: :patch, url: "/api/exchange_items/1.json"

    subject { patch api_exchange_item_path(exchange_item), params: params, headers: authenticated_headers({}, user) }

    let(:params) { { exchange_item: { name: 'New name' } } }

    context 'when user is authenticated' do
      context 'when user is not an owner of exchange item' do
        let(:exchange_item) { create(:exchange_item) }

        before { subject }

        it 'returns 403' do
          expect(response).to(have_http_status(403))
        end
      end

      context 'when user is an owner of exchange item' do
        let(:exchange_item) { create(:exchange_item, user:) }

        it 'returns 200' do
          subject
          expect(response).to(have_http_status(200))
        end

        it 'updates exchange item' do
          expect { subject }.to change { exchange_item.reload.name }.to('New name')
        end
      end
    end
  end

  describe 'PATCH #activate' do
    it_behaves_like 'protected endpoint', method: :patch, url: "/api/exchange_items/1/activate.json"

    subject { patch activate_api_exchange_item_path(exchange_item), headers: authenticated_headers({}, user) }

    context 'when user is authenticated' do
      context 'when user is not an owner of exchange item' do
        let(:exchange_item) { create(:exchange_item) }

        before { subject }

        it 'returns 403' do
          expect(response).to(have_http_status(403))
        end
      end

      context 'when user is an owner of exchange item' do
        let(:exchange_item) { create(:exchange_item, user:, status: :inactive) }

        it 'returns 200' do
          subject
          expect(response).to(have_http_status(200))
        end

        it 'updates exchange item' do
          expect { subject }.to change { exchange_item.reload.status }.to('active')
        end
      end
    end
  end

  describe 'PATCH #cancel' do
    it_behaves_like 'protected endpoint', method: :patch, url: "/api/exchange_items/1/cancel.json"

    subject { patch cancel_api_exchange_item_path(exchange_item), headers: authenticated_headers({}, user) }

    context 'when user is authenticated' do
      context 'when user is not an owner of exchange item' do
        let(:exchange_item) { create(:exchange_item) }

        before { subject }

        it 'returns 403' do
          expect(response).to(have_http_status(403))
        end
      end

      context 'when user is an owner of exchange item' do
        let(:exchange_item) { create(:exchange_item, user:, status: :active) }

        it 'returns 200' do
          subject
          expect(response).to(have_http_status(200))
        end

        it 'updates exchange item' do
          expect { subject }.to change { exchange_item.reload.status }.to('cancelled')
        end
      end
    end
  end

  describe 'PATCH #exchange' do
    it_behaves_like 'protected endpoint', method: :patch, url: "/api/exchange_items/1/exchange.json"

    subject { patch exchange_api_exchange_item_path(exchange_item), headers: authenticated_headers({}, user) }

    context 'when user is authenticated' do
      context 'when user is not an owner of exchange item' do
        let(:exchange_item) { create(:exchange_item) }

        before { subject }

        it 'returns 403' do
          expect(response).to(have_http_status(403))
        end
      end

      context 'when user is an owner of exchange item' do
        let(:exchange_item) { create(:exchange_item, user:, status: :active) }

        it 'returns 200' do
          subject
          expect(response).to(have_http_status(200))
        end

        it 'updates exchange item' do
          expect { subject }.to change { exchange_item.reload.status }.to('exchanged')
        end
      end
    end
  end

  describe 'PATCH #inactivate' do
    it_behaves_like 'protected endpoint', method: :patch, url: "/api/exchange_items/1/inactivate.json"

    subject { patch inactivate_api_exchange_item_path(exchange_item), headers: authenticated_headers({}, user) }

    context 'when user is authenticated' do
      context 'when user is not an owner of exchange item' do
        let(:exchange_item) { create(:exchange_item) }

        before { subject }

        it 'returns 403' do
          expect(response).to(have_http_status(403))
        end
      end

      context 'when user is an owner of exchange item' do
        let(:exchange_item) { create(:exchange_item, user:, status: :active) }

        it 'returns 200' do
          subject
          expect(response).to(have_http_status(200))
        end

        it 'updates exchange item' do
          expect { subject }.to change { exchange_item.reload.status }.to('inactive')
        end
      end
    end
  end
end
