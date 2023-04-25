module TravelSessions
  class OriginSessionHandler
    def initialize(params, user, machine)
      @expires = params[:expires]
      @start_longitude = params[:start_longitude]
      @start_latitude = params[:start_latitude]
      @user = user
      @machine = machine
    end

    def call
      return Resonad.Failure('Session is already in progress') if user.travel_sessions.active.present?

      return Resonad.Failure('Request is invalid') unless OriginValidator.new(machine, expires).call

      travel_session = user.travel_sessions.build(machine: machine,
                                                  active: true,
                                                  start_latitude: start_latitude,
                                                  start_longitude: start_longitude)
      if travel_session.save
        Resonad.Success(travel_session)
      else
        Resonad.Failure(purchase.errors.full_messages)
      end
    end

    private

    attr_reader :user, :machine, :expires, :start_latitude, :start_longitude
  end
end