# frozen_string_literal: true

module DistanceMatrix
  module Helpers
    module QueryParamsHelper
      STATIC_PARAMS = {
        mode: 'driving',
        units: 'metric',
        key: Rails.env.test? ? 'google_api_key' : ENV.fetch('GOOGLE_API_KEY', nil)
      }.freeze

      TRAVEL_SESSION_FIELDS_MAPPER = {
        origins: %w[start_latitude start_longitude],
        destinations: %w[end_latitude end_longitude]
      }.freeze

      def build_query_params(travel_session)
        query_params = '?'

        STATIC_PARAMS.each do |key, value|
          query_params += "#{key}=#{value}&"
        end

        TRAVEL_SESSION_FIELDS_MAPPER.each do |key, fields|
          query_params += "#{key}=#{travel_session.attributes.extract!(*fields).values.join(',')}&"
        end

        query_params
      end
    end
  end
end
