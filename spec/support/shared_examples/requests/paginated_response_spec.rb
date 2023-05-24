# frozen_string_literal: true

require "spec_helper"

shared_examples_for "Paginated response" do
  it 'contains all paginated information' do
    subject
    json_response = JSON.parse(response.body)
    expect(json_response['total_pages']).not_to eq(nil)
    expect(json_response['current_page']).not_to eq(nil)
    expect(json_response['resources'].size).not_to eq(nil)
  end
end
