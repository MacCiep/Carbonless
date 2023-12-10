module Moderation
  class ModerateMessage
    def initialize(user, message)
      @user = user
      @message = message
    end

    def call
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
      @valid ||= response.dig('results')[0]['category_scores'].values.none? { |score| score > ENV.fetch('MODERATION_RESTRICTION', 0.1).to_f }
    end
  end
end