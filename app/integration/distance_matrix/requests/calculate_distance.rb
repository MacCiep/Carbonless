# frozen_string_literal: true

module DistanceMatrix
  module Requests
    class CalculateDistance
      attr_reader :travel_session

      include DistanceMatrix::Helpers::QueryParamsHelper

      HOST = 'https://maps.googleapis.com/maps/api/distancematrix/json'

      def initialize(travel_session)
        @travel_session = travel_session
      end

      def call
        response = client.post(build_query_params(travel_session).to_s)

        return unless response.status == 200

        response_body = JSON.parse response.body
        response_body.dig(:rows, :elements, :distance, :value)
        extract(response_body)
      end

      private

      # :reek:UtilityFunction
      def client
        Faraday.new(
          url: HOST,
          headers: { 'Content-Type' => 'application/json' }
        )
      end

      # :reek:UtilityFunction
      def extract(response_body)
        response_body['rows']&.first&.dig('elements')&.first&.dig('distance', 'value')
      end
    end
  end
end
