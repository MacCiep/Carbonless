# frozen_string_literal: true

module TgtgMicroservice
  module Requests
    class AddOrderPoints
      attr_reader :user

      ENDPOINT = 'users'
      POINTS_PER_ORDER = 100

      def initialize(user)
        @user = user
      end

      def call
        return unless user.tgtg_id

        response = Faraday.get("#{ENV.fetch('TGTG_MICROSERVICE_URL', nil)}/#{ENDPOINT}/#{user.tgtg_id}")
        return nil unless response.status == 200

        response_body = JSON.parse response.body
        response_body['number_of_unmarked_orders'] * POINTS_PER_ORDER
      end
    end
  end
end
