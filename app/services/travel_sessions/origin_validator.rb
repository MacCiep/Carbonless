# frozen_string_literal: true

module TravelSessions
  class OriginValidator < MachineValidator
    def initialize(machine, expires)
      super()
      @machine = machine
      @expires = expires
    end

    def call
      validate_expiration_date
    end

    private

    MAX_EXPIRATION_OFFSET = 20.minutes

    attr_reader :machine, :expires

    def validate_expiration_date
      decrypted_expires = encryptor.decrypt_and_verify(expires)
      expires_date = decrypted_expires.to_datetime.in_time_zone('UTC')
      verification_time < expires_date && expires_date < verification_time + MAX_EXPIRATION_OFFSET
    end
  end
end
