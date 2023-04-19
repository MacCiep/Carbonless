module DistanceMatrix
  module Requests
    class CalculateDistance

      attr_reader :user, :travel_session

      include DistanceMatrix::Helpers::QueryParamsHelper

      HOST = 'https://maps.googleapis.com/maps/api/distancematrix/json'

      def initialize(user, travel_session)
        @user = user
        @travel_session = travel_session
      end

      def call
        response = client.post("#{build_query_params(travel_session)}")

        return unless response.status == 200

        response_body = JSON.parse response.body
        response_body.dig(:rows, :elements, :distance, :value)
        extract(response_body)
      end

      private

      def client
        Faraday.new(
          url: HOST,
          headers: {'Content-Type' => 'application/json'}
        )
      end

      def extract(response_body)
        response_body.dig('rows')&.first&.dig('elements')&.first&.dig('distance', 'value')
      end
    end
  end
end