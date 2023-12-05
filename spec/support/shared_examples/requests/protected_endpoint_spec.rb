# frozen_string_literal: true

shared_examples 'response status' do |status|
  it "responds with #{status}" do
    expect(response).to have_http_status(status)
  end
end

shared_examples 'protected endpoint' do |method:, url:|
  subject { send(method, url, headers: headers) }

  let(:headers) { {} }
  let(:user) { create(:user) }

  context 'when authorization header is missing' do
    before { subject }

    it_behaves_like 'response status', :unauthorized
  end

  context 'when authorization header is present' do
    let(:headers) { authenticated_headers({}, user) }
    subject { send(method, url, headers: headers) rescue nil } # we don't care about the response - just a status

    context 'when access token is valid' do
      before { subject }

      it { expect(response).not_to have_http_status(:unauthorized) }
      it { expect(response).not_to have_http_status(:forbidden) }
    end

    context 'when access token is invalid' do
      let(:access_token) { 'Wrong access token' }
      let(:headers) { { 'Authorization' => "Bearer #{access_token}" } }

      before { subject }

      it_behaves_like 'response status', :unauthorized
    end

    context 'when access token expired' do
      before do
        headers
        Timecop.travel(5.hours.to_i + 1.hour.to_i)
        subject
      end

      it_behaves_like 'response status', :unauthorized
    end
  end
end