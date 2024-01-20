# frozen_string_literal: true

class MachineHandler
  def initialize(params, user)
    @params = params
    @machine_uuid = params[:uuid]
    @user = user
  end

  def call
    return Resonad.Failure('Request is invalid') if machine.blank?

    if machine.service_type == 'travel'
      TravelSessions::OriginSessionHandler.new(params, user, machine).call
    else
      Purchases::Handler.new(params, user, machine).call
    end
  end

  private

  attr_reader :params, :machine_uuid, :user

  def machine
    @machine ||= Machine.find_by(uuid: machine_uuid)
  end
end
