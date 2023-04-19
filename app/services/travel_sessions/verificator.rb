module TravelSessions
  class Verificator < SessionVerificator
    def initialize(machine_params, current_session = nil)
      super
      @expires = machine_params[:expires]
    end

    def call
      verify_current_session && verify_expiration_date
    end

    private

    SESSION_MAX_LIFETIME = 90.minutes

    def verify_current_session
      return true if current_session.blank?
      return false if verification_time > current_session.created_at + SESSION_MAX_LIFETIME

      current_session.machine.uuid == uuid
    end

    def verify_expiration_date
      decrypted_expires = encryptor.decrypt_and_verify(expires)
      expires_date = decrypted_expires.to_datetime
      verification_time < expires_date && expires_date < verification_time + 20.minutes
    end

    def verification_time
      @verification_time ||= DateTime.now
    end

    attr_reader :uuid, :expires, :current_session
  end
end