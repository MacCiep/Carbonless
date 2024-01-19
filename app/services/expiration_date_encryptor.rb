# frozen_string_literal: true

class ExpirationDateEncryptor
  def initialize(payload, secret)
    @payload = payload
    @secret = secret
  end

  def call
    encryptor.encrypt_and_sign(payload)
  end

  private

  attr_reader :payload

  def encryptor
    ActiveSupport::MessageEncryptor.new(@secret)
  end
end
