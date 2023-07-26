module TravelSessions
  class DestinationSessionHandler
    def initialize(params, user, travel_session)
      @expires = params[:expires]
      @travel_destination_params = params.slice(:end_longitude, :end_latitude)
      @machine_uuid = params[:uuid]
      @travel_session = travel_session
      @user = user
    end

    def call
      return Resonad.Failure('Request is invalid') unless machine && DestinationValidator.new(machine, expires, travel_session).call

      @travel_session.assign_attributes(@travel_destination_params)
      car_distance = DistanceMatrix::Requests::CalculateDistance.new(@travel_session).call

      # TODO: Message should be equal to above failure message
      return Resonad.Failure('Wrong coordinates') unless car_distance.present?

      ActiveRecord::Base.transaction do
        if travel_session.update(car_distance: car_distance, success: true, active: false)
          session_results = TravelSessions::TravelSessionCalculator.new(car_distance).call
          UserUpdater.new(user: user,
                          machine: machine,
                          points: session_results[:points],
                          carbon_saved: session_results[:carbon_saved]).call

          Resonad.Success(DestinationTravelSessionSerializer.new(session_results, user).call)
        else
          Resonad.Failure(travel_session.errors.full_messages)
        end
      end
    end

    private

    def machine
      @machine ||= Machine.find_by(uuid: machine_uuid)
    end

    attr_reader :expires, :travel_session_origin_params, :machine_uuid, :travel_session, :user
  end
end