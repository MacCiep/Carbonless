module TravelSessions
  class Validator < SessionValidator
    def initialize(machine_params, current_session = nil)
      @machine_uuid = machine_params[:uuid]
      @expires = machine_params[:expires]
      @current_session = current_session
    end

    def call
      return false unless super

      verify_current_session && validate_expiration_date
    end

    private

    attr_reader :machine_uuid, :expires, :current_session

    SESSION_MAX_LIFETIME = 90.minutes

    def verify_current_session
      return true if current_session.blank?
      return false if verification_time > current_session.created_at + SESSION_MAX_LIFETIME

      current_session.machine.uuid == machine_uuid
    end

    def validate_expiration_date
      decrypted_expires = encryptor.decrypt_and_verify(expires)
      expires_date = decrypted_expires.to_datetime.in_time_zone("UTC")
      verification_time < expires_date && expires_date < verification_time + 20.minutes
    end

    attr_reader :uuid, :expires, :current_session
  end
end