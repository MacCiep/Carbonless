# frozen_string_literal: true

module Moderation
  class ModerateMessage
    def initialize(user, message)
      @user = user
      @message = message
    end

    def call
      return true if ENV.fetch('OPENAI_ENABLED', nil)

      client = OpenAI::Client.new
      @response = client.moderations(parameters: { input: message })
      mark_flagged_message unless valid?
      valid
    end

    private

    attr_reader :message, :valid, :response, :user

    def mark_flagged_message
      user.increment_flagged_messages
    end

    def valid?
      @valid ||= response['results'][0]['category_scores'].values.none? do |score|
        score > ENV.fetch('MODERATION_RESTRICTION', 0.1).to_f
      end
    end
  end
end
