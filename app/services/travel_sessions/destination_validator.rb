module TravelSessions
  class DestinationValidator < OriginValidator
    def initialize(machine, expires, current_session)
      @machine = machine
      @expires = expires
      @current_session = current_session
    end

    def call
      verify_current_session && validate_expiration_date
    end

    private

    attr_reader :machine, :expires, :current_session

    SESSION_MAX_LIFETIME = 90.minutes

    def verify_current_session
      return false if current_session.nil?
      return false if verification_time > current_session.created_at + SESSION_MAX_LIFETIME

      current_session.machine.uuid == machine.uuid
    end
  end
end