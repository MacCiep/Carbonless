# frozen_string_literal: true

if ENV.fetch('OPENAI_ENABLED') == 'true'
  OpenAI.configure do |config|
    config.access_token = ENV.fetch('OPENAI_ACCESS_TOKEN')
  end
end