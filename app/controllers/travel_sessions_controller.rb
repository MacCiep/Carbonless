class TravelSessionsController < ApplicationController
  before_action :set_travel_session, only: [:update, :destroy]

  def create
    render json: { message: 'session is in progress' }, status: :forbidden and return if current_user.travel_sessions.active.present?

    render status: 422 and return unless TravelSessions::Verificator.new(travel_session_params).call

    travel_session = current_user.travel_sessions.build(session_build_attributes)
    if travel_session.save
      render json: travel_session, status: 202
    else
      render json: travel_session.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    render status: 422 and return unless TravelSessions::Verificator.new(travel_session_params, @travel_session).call

    @travel_session.assign_attributes(travel_session_end_position_params)
    @car_distance = DistanceMatrix::Requests::CalculateDistance.new(current_user, @travel_session).call

    render status: 422 and return unless @car_distance.present?

    @travel_session.assign_attributes(session_update_attributes)
    if @travel_session.save
      session_results = TravelSessions::TravelSessionCalculator.new(@car_distance).call
      UserUpdater.new(user: current_user,
                      points: session_results[:points],
                      carbon_saved: session_results[:carbon_saved]).call

      render json: {
        carbon_saved: current_user.total_carbon_saved.to_f.round(2),
        points: current_user.points,
        session_carbon_saved: session_results[:carbon_saved],
        session_points_saved: session_results[:points]
      }
    else
      render json: @travel_session.errors.full_messages, status: 422
    end
  end

  def destroy
    if @travel_session.delete
      render status: :ok
    else
      render status: :unprocessable_entity
    end
  end

  private

  def set_travel_session
    @travel_session = current_user.travel_sessions.active.first
  end

  def session_build_attributes
    travel_session_position_params.to_hash.merge(
      machine_id: Machine.find_by(uuid: travel_session_params[:uuid]).id,
      active: true
    )
  end

  def session_update_attributes
    {
      active: false,
      car_distance: @car_distance
    }
  end

  def travel_session_params
    params.require(:travel_session).permit(:uuid, :expires)
  end

  def travel_session_position_params
    params.require(:travel_session).permit(:start_longitude, :start_latitude)
  end

  def travel_session_end_position_params
    params.require(:travel_session).permit(:end_longitude, :end_latitude)
  end
end
