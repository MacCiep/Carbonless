class MachineHandlersController < ApplicationController
  before_action :set_travel_session, only: [:update, :destroy]

  def create
    result = MachineHandler.new(handler_params, current_user).call
    if result.success?
      render json: result.value, status: success_status(result.value)
    else
      render json: { message: result.error }, status: :unprocessable_entity
    end
  end

  def update
    result = TravelSessions::DestinationSessionHandler.new(handler_params, current_user, travel_session).call
    if result.success?
      render json: result.value, status: success_status(result.value)
    else
      render json: { message: result.error }, status: :unprocessable_entity
    end
  end

  def destroy
    if travel_session.present? && travel_session.destroy
      head :ok
    else
      head :unprocessable_entity
    end
  end

  private

  attr_reader :travel_session

  def success_status(object)
    object.is_a?(TravelSession) ? 202 : 200
  end

  def set_travel_session
    @travel_session = current_user.travel_sessions.active.first
  end

  def handler_params
    params.require(:handler).permit(:uuid,
                                    :expires,
                                    :start_longitude,
                                    :start_latitude,
                                    :end_longitude,
                                    :end_latitude)
  end
end