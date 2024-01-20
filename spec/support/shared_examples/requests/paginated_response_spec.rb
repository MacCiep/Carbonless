# frozen_string_literal: true

require 'spec_helper'

shared_examples_for 'Paginated response' do
  it 'contains all paginated information' do
    json_response = JSON.parse(response.body)
    expect(json_response['records'].size).not_to be_nil
    expect(json_response['metadata']).not_to be_nil
    expect(json_response['metadata']['pages']).not_to be_nil
    expect(json_response['metadata']['page']).not_to be_nil
    expect(json_response['metadata']['count']).not_to be_nil
    expect(json_response['metadata']['items']).not_to be_nil
  end
  # rubocop:enable RSpec/ExampleLength, RSpec/MultipleExpectations
end
