# frozen_string_literal: true

module TgtgMicroservice
  module Requests
    class RefreshAccess
      attr_reader :user

      ENDPOINT = 'authorize'

      def initialize(user)
        @user = user
      end

      def call
        tgtg_id = user.tgtg_id
        return if tgtg_id

        response = Faraday.put("#{ENV.fetch('TGTG_MICROSERVICE_URL', nil)}/#{ENDPOINT}/#{tgtg_id}")

        response.status == 200
      end
    end
  end
end
